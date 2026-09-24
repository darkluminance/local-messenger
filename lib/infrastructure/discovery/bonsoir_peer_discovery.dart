import 'dart:async';
import 'dart:io';

import 'package:bonsoir/bonsoir.dart';
import 'package:local_messenger/domain/contracts.dart';
import 'package:local_messenger/domain/identity.dart';
import 'package:local_messenger/infrastructure/discovery/presence_registry.dart';
import 'package:local_messenger/phase0/constants.dart';

/// The native Bonsoir actions are wrapped so lifecycle behavior can be tested
/// without a platform channel or a physical LAN.
abstract interface class BonjourDiscoveryAction {
  Stream<BonsoirDiscoveryEvent> get events;
  Future<void> initialize();
  Future<void> start();
  Future<void> stop();
  Future<void> resolve(BonsoirService service);
}

abstract interface class BonjourBroadcastAction {
  Stream<BonsoirBroadcastEvent> get events;
  Future<void> initialize();
  Future<void> start();
  Future<void> stop();
}

abstract interface class BonjourActionFactory {
  BonjourDiscoveryAction discovery(String type);
  BonjourBroadcastAction broadcast(BonsoirService service);
}

final class PluginBonjourActionFactory implements BonjourActionFactory {
  const PluginBonjourActionFactory();

  @override
  BonjourDiscoveryAction discovery(String type) =>
      _PluginDiscoveryAction(BonsoirDiscovery(type: type, printLogs: false));

  @override
  BonjourBroadcastAction broadcast(BonsoirService service) =>
      _PluginBroadcastAction(
        BonsoirBroadcast(service: service, printLogs: false),
      );
}

final class _PluginDiscoveryAction implements BonjourDiscoveryAction {
  const _PluginDiscoveryAction(this._delegate);

  final BonsoirDiscovery _delegate;

  @override
  Stream<BonsoirDiscoveryEvent> get events => _delegate.eventStream!;

  @override
  Future<void> initialize() => _delegate.initialize();

  @override
  Future<void> start() => _delegate.start();

  @override
  Future<void> stop() => _delegate.stop();

  @override
  Future<void> resolve(BonsoirService service) async =>
      _delegate.serviceResolver.resolveService(service);
}

final class _PluginBroadcastAction implements BonjourBroadcastAction {
  const _PluginBroadcastAction(this._delegate);

  final BonsoirBroadcast _delegate;

  @override
  Stream<BonsoirBroadcastEvent> get events => _delegate.eventStream!;

  @override
  Future<void> initialize() => _delegate.initialize();

  @override
  Future<void> start() => _delegate.start();

  @override
  Future<void> stop() => _delegate.stop();
}

/// Each string identifies one usable interface and its current addresses.
/// Changes to the set mean Bonsoir must browse and advertise again.
typedef InterfaceSnapshotProbe = Future<Set<String>> Function();

Future<Set<String>> probeNetworkInterfaces() async {
  final interfaces = await NetworkInterface.list(includeLoopback: false);
  return <String>{
    for (final interface in interfaces)
      if (interface.addresses.any((address) => !address.isLoopback))
        '${interface.index}:${interface.name}:'
            '${(interface.addresses.map((address) => address.address).toList()..sort()).join(",")}',
  };
}

/// DNS-SD discovery. TXT names and IDs are untrusted presence hints;
/// the later secure session supplies the authenticated profile.
final class BonsoirPeerDiscovery implements PeerDiscovery {
  BonsoirPeerDiscovery({
    DeviceId? localDeviceId,
    BonjourActionFactory actionFactory = const PluginBonjourActionFactory(),
    this._interfaceProbe = probeNetworkInterfaces,
    DateTime Function()? clock,
    this._maintenanceInterval = const Duration(seconds: 5),
    Duration presenceLifetime = defaultPresenceLifetime,
  }) : _registry = localDeviceId == null
           ? null
           : PresenceRegistry(
               localDeviceId: localDeviceId,
               lifetime: presenceLifetime,
             ),
       _presenceLifetime = presenceLifetime,
       _factory = actionFactory,
       _clock = clock ?? DateTime.now;

  PresenceRegistry? _registry;
  final Duration _presenceLifetime;
  final BonjourActionFactory _factory;
  final InterfaceSnapshotProbe _interfaceProbe;
  final DateTime Function() _clock;
  final Duration _maintenanceInterval;
  final StreamController<List<PeerPresence>> _peerChanges =
      StreamController<List<PeerPresence>>.broadcast();
  final StreamController<DiscoveryStatus> _statusChanges =
      StreamController<DiscoveryStatus>.broadcast();

  Future<void> _pending = Future<void>.value();
  Timer? _maintenance;
  Set<String>? _interfaces;
  IdentityProfile? _advertisedProfile;
  int? _advertisedPort;
  Set<String> _capabilities = const <String>{};
  bool _browseRequested = false;
  bool _disposed = false;
  bool _advertising = false;
  bool _browsing = false;
  bool _restartRequested = false;
  DiscoveryIssue _issue = DiscoveryIssue.none;
  String? _detail;
  BonjourDiscoveryAction? _discovery;
  BonjourBroadcastAction? _broadcast;
  StreamSubscription<BonsoirDiscoveryEvent>? _discoveryEvents;
  StreamSubscription<BonsoirBroadcastEvent>? _broadcastEvents;
  final Map<String, BonsoirService> _found = <String, BonsoirService>{};

  DiscoveryStatus get currentStatus => DiscoveryStatus(
    advertising: _advertising,
    browsing: _browsing,
    activeInterfaceCount: _interfaces?.length ?? 0,
    issue: _issue,
    detail: _detail,
  );

  List<PeerPresence> get currentPeers =>
      _registry?.peers ?? const <PeerPresence>[];

  @override
  Stream<List<PeerPresence>> watchPeers() =>
      Stream<List<PeerPresence>>.multi((controller) {
        controller.add(currentPeers);
        final subscription = _peerChanges.stream.listen(controller.add);
        controller.onCancel = subscription.cancel;
      });

  @override
  Stream<DiscoveryStatus> watchStatus() =>
      Stream<DiscoveryStatus>.multi((controller) {
        controller.add(currentStatus);
        final subscription = _statusChanges.stream.listen(controller.add);
        controller.onCancel = subscription.cancel;
      });

  @override
  Future<void> advertise({
    required IdentityProfile profile,
    required int port,
    required Set<String> capabilities,
  }) {
    if ((_registry != null && profile.deviceId != _registry!.localDeviceId) ||
        profile.deviceId != DeviceId.fromPublicKey(profile.publicKey) ||
        profile.revision < 1 ||
        port < 1 ||
        port > 65535 ||
        capabilities.isEmpty ||
        !RegExp(r'^[a-z0-9]+(?:,[a-z0-9]+)*$')
            .hasMatch((capabilities.toList()..sort()).join(',')) ||
        capabilities.join(',').length > 64) {
      throw ArgumentError('Invalid local DNS-SD advertisement.');
    }
    return _enqueue(() async {
      _registry ??= PresenceRegistry(
        localDeviceId: profile.deviceId,
        lifetime: _presenceLifetime,
      );
      final wasAdvertising = _advertisedProfile != null;
      _advertisedProfile = profile;
      _advertisedPort = port;
      _capabilities = Set<String>.of(capabilities);
      if (wasAdvertising) {
        await _stopBroadcast();
      }
      await _refreshNetwork();
      _startMaintenance();
    });
  }

  @override
  Future<void> browse() => _enqueue(() async {
    _browseRequested = true;
    await _refreshNetwork();
    _startMaintenance();
  });

  @override
  Future<void> stopAdvertising() => _enqueue(() async {
    _advertisedProfile = null;
    _advertisedPort = null;
    await _stopBroadcast();
    _stopMaintenanceIfIdle();
  });

  @override
  Future<void> stopBrowsing() => _enqueue(() async {
    _browseRequested = false;
    await _stopDiscovery();
    _clearPresence();
    _stopMaintenanceIfIdle();
  });

  /// Safe to call on resume and useful for an explicit network-change signal.
  @override
  Future<void> refreshNetwork({bool restart = false}) => _enqueue(() async {
    if (restart) _restartRequested = true;
    await _refreshNetwork();
  });

  Future<void> dispose() => _enqueue(() async {
    _browseRequested = false;
    _advertisedProfile = null;
    _maintenance?.cancel();
    _maintenance = null;
    await _stopDiscovery();
    await _stopBroadcast();
    _clearPresence();
    _disposed = true;
    await _peerChanges.close();
    await _statusChanges.close();
  });

  Future<void> _enqueue(Future<void> Function() action) {
    if (_disposed) {
      return Future<void>.error(StateError('Discovery has been disposed.'));
    }
    final result = Completer<void>();
    _pending = _pending.then((_) async {
      try {
        await action();
        result.complete();
      } catch (error, stackTrace) {
        result.completeError(error, stackTrace);
      }
    });
    return result.future;
  }

  void _startMaintenance() {
    _maintenance ??= Timer.periodic(_maintenanceInterval, (_) {
      unawaited(
        _enqueue(() async {
          if (_registry?.expire(_clock()) ?? false) {
            _emitPeers();
          }
          await _refreshNetwork();
          final action = _discovery;
          if (action != null) {
            for (final service in _found.values.toList()) {
              await _resolve(action, service);
            }
          }
        }).catchError((Object error) {
          _setIssue(_issueFor(error), '$error');
        }),
      );
    });
  }

  void _stopMaintenanceIfIdle() {
    if (!_browseRequested && _advertisedProfile == null) {
      _maintenance?.cancel();
      _maintenance = null;
    }
  }

  Future<void> _refreshNetwork() async {
    Set<String> interfaces;
    try {
      interfaces = await _interfaceProbe();
    } catch (error) {
      _interfaces = <String>{};
      await _stopDiscovery();
      await _stopBroadcast();
      _clearPresence();
      _setIssue(DiscoveryIssue.serviceUnavailable, '$error');
      return;
    }
    if (_interfaces == null ||
        !_sameSet(_interfaces!, interfaces) ||
        _restartRequested) {
      _restartRequested = false;
      _interfaces = Set<String>.of(interfaces);
      await _stopDiscovery();
      await _stopBroadcast();
      _clearPresence();
      _emitStatus();
    }
    if (interfaces.isEmpty) {
      _setIssue(DiscoveryIssue.noNetwork, 'No active local network interface.');
      return;
    }
    if (_issue == DiscoveryIssue.noNetwork) {
      _setIssue(DiscoveryIssue.none, null);
    }
    if (_advertisedProfile != null && _broadcast == null) {
      await _startBroadcast();
    }
    if (_browseRequested && _discovery == null) {
      await _startDiscovery();
    }
  }

  Future<void> _startBroadcast() async {
    final profile = _advertisedProfile!;
    final service = BonsoirService(
      name: 'localmsg-${profile.deviceId.hex.substring(0, 16)}',
      type: localMessengerServiceType,
      port: _advertisedPort!,
      attributes: <String, String>{
        'v': '$localMessengerProtocolMajor.$localMessengerProtocolMinor',
        'id': profile.deviceId.hex,
        'caps': (_capabilities.toList()..sort()).join(','),
        'profile': '${profile.revision}',
        'name': profile.displayName.value,
      },
    );
    final action = _factory.broadcast(service);
    try {
      await action.initialize();
      _broadcast = action;
      _broadcastEvents = action.events.listen((event) {
        if (!identical(_broadcast, action)) return;
        if (event is BonsoirBroadcastStartedEvent) {
          _advertising = true;
          _clearIssueIfReady();
        } else if (event is BonsoirBroadcastStoppedEvent) {
          _advertising = false;
          _emitStatus();
        }
      }, onError: (Object error) => _onActionError(error));
      await action.start();
    } catch (error) {
      _setIssue(_issueFor(error), '$error');
      await _stopBroadcast();
    }
  }

  Future<void> _startDiscovery() async {
    final action = _factory.discovery(localMessengerServiceType);
    try {
      await action.initialize();
      _discovery = action;
      _discoveryEvents = action.events.listen(
        (event) => _onDiscoveryEvent(action, event),
        onError: (Object error) => _onActionError(error),
      );
      await action.start();
    } catch (error) {
      _setIssue(_issueFor(error), '$error');
      await _stopDiscovery();
    }
  }

  void _onDiscoveryEvent(
    BonjourDiscoveryAction action,
    BonsoirDiscoveryEvent event,
  ) {
    if (!identical(_discovery, action)) return;
    switch (event) {
      case BonsoirDiscoveryStartedEvent():
        _browsing = true;
        _clearIssueIfReady();
      case BonsoirDiscoveryServiceFoundEvent(:final service):
        _remember(service);
        unawaited(_resolve(action, service));
      case BonsoirDiscoveryServiceResolvedEvent(:final service):
        _remember(service);
        _observe(service);
      case BonsoirDiscoveryServiceUpdatedEvent(:final service):
        _remember(service);
        if (service.hostAddresses.isNotEmpty) _observe(service);
      case BonsoirDiscoveryServiceLostEvent(:final service):
        _found.remove(_serviceKey(service));
        if (_registry?.lose(service.name) ?? false) _emitPeers();
      case BonsoirDiscoveryServiceResolveFailedEvent():
        _setIssue(
          DiscoveryIssue.resolveFailed,
          'A service could not be resolved.',
        );
      case BonsoirDiscoveryStoppedEvent():
        _browsing = false;
        _emitStatus();
      case BonsoirDiscoveryUnknownEvent():
        break;
    }
  }

  void _remember(BonsoirService service) {
    final key = _serviceKey(service);
    _found.remove(key);
    _found[key] = service;
    if (_found.length > maximumStoredObservations) {
      _found.remove(_found.keys.first);
    }
  }

  Future<void> _resolve(
    BonjourDiscoveryAction action,
    BonsoirService service,
  ) async {
    if (!identical(_discovery, action)) return;
    try {
      await action.resolve(service);
    } catch (error) {
      if (identical(_discovery, action)) {
        _setIssue(DiscoveryIssue.resolveFailed, '$error');
      }
    }
  }

  void _observe(BonsoirService service) {
    final record = DiscoveryRecord.parse(
      serviceName: service.name,
      type: service.type,
      port: service.port,
      attributes: service.attributes,
      hostAddresses: service.hostAddresses,
    );
    if (record == null) {
      if (_registry?.lose(service.name) ?? false) _emitPeers();
      return;
    }
    if (_registry?.observe(record, _clock()) ?? false) _emitPeers();
    if (_issue == DiscoveryIssue.resolveFailed) {
      _setIssue(DiscoveryIssue.none, null);
    }
  }

  Future<void> _stopDiscovery() async {
    final action = _discovery;
    _discovery = null;
    await _discoveryEvents?.cancel();
    _discoveryEvents = null;
    _found.clear();
    _browsing = false;
    if (action != null) {
      try {
        await action.stop();
      } catch (error) {
        _setIssue(DiscoveryIssue.interrupted, '$error');
      }
    }
    _emitStatus();
  }

  Future<void> _stopBroadcast() async {
    final action = _broadcast;
    _broadcast = null;
    await _broadcastEvents?.cancel();
    _broadcastEvents = null;
    _advertising = false;
    if (action != null) {
      try {
        await action.stop();
      } catch (error) {
        _setIssue(DiscoveryIssue.interrupted, '$error');
      }
    }
    _emitStatus();
  }

  void _clearPresence() {
    if (_registry?.clear() ?? false) _emitPeers();
  }

  void _onActionError(Object error) {
    final issue = _issueFor(error);
    if (issue != DiscoveryIssue.permissionDenied) {
      _restartRequested = true;
    }
    _setIssue(issue, '$error');
  }

  void _clearIssueIfReady() {
    if ((_advertisedProfile == null || _advertising) &&
        (!_browseRequested || _browsing)) {
      _setIssue(DiscoveryIssue.none, null);
    } else {
      _emitStatus();
    }
  }

  void _setIssue(DiscoveryIssue issue, String? detail) {
    _issue = issue;
    _detail = detail;
    _emitStatus();
  }

  void _emitPeers() {
    if (!_peerChanges.isClosed) _peerChanges.add(currentPeers);
  }

  void _emitStatus() {
    if (!_statusChanges.isClosed) _statusChanges.add(currentStatus);
  }
}

String _serviceKey(BonsoirService service) =>
    '${service.type}\u0000${service.name}';

bool _sameSet(Set<String> left, Set<String> right) =>
    left.length == right.length && left.containsAll(right);

DiscoveryIssue _issueFor(Object error) {
  final detail = '$error'.toLowerCase();
  if (detail.contains('permission') ||
      detail.contains('noauth') ||
      detail.contains('policydenied') ||
      detail.contains('not authorized')) {
    return DiscoveryIssue.permissionDenied;
  }
  return DiscoveryIssue.serviceUnavailable;
}
