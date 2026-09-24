import 'dart:async';

import 'package:bonsoir/bonsoir.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:local_messenger/domain/contracts.dart';
import 'package:local_messenger/domain/identity.dart';
import 'package:local_messenger/infrastructure/discovery/bonsoir_peer_discovery.dart';

void main() {
  final now = DateTime.utc(2026, 9, 23);
  final localKey = PublicKeyBytes(List<int>.filled(32, 1));
  final localId = DeviceId.fromPublicKey(localKey);
  final remoteId = DeviceId(List<int>.filled(32, 2));

  IdentityProfile profile(int revision, {String name = 'Raiyan'}) =>
      IdentityProfile(
        deviceId: localId,
        publicKey: localKey,
        displayName: DisplayName.parse(name),
        revision: revision,
        createdAt: now,
        updatedAt: now,
      );

  BonsoirService remote(
    String name,
    String address, {
    DeviceId? id,
    String? advertisedName,
  }) {
    final attributes = <String, String>{
      'v': '1.0',
      'id': (id ?? remoteId).hex,
      'caps': 'text',
      'profile': '1',
    };
    if (advertisedName != null) attributes['name'] = advertisedName;
    return BonsoirService(
      name: name,
      type: '_localmsg._tcp',
      port: 45873,
      attributes: attributes,
      hostAddresses: <String>[address],
    );
  }

  test('advertises, resolves, deduplicates, and stops cleanly', () async {
    final factory = _FakeActionFactory();
    final discovery = BonsoirPeerDiscovery(
      actionFactory: factory,
      interfaceProbe: () async => <String>{'1:lan:192.168.1.10'},
      clock: () => now,
    );
    final peers = <List<PeerPresence>>[];
    final subscription = discovery.watchPeers().listen(peers.add);

    await discovery.advertise(
      profile: profile(1),
      port: 45873,
      capabilities: <String>{'text'},
    );
    await discovery.browse();
    expect(discovery.currentStatus.isActive, isTrue);
    expect(factory.broadcasts, hasLength(1));
    expect(factory.broadcasts.single.service.attributes['id'], localId.hex);
    expect(factory.broadcasts.single.service.attributes['profile'], '1');
    expect(factory.broadcasts.single.service.attributes['name'], 'Raiyan');
    expect(
      factory.broadcasts.single.service.name.length,
      lessThanOrEqualTo(63),
    );

    final first = remote('first', '192.168.1.20', advertisedName: 'Alex');
    factory.discoveries.single.emit(
      BonsoirDiscoveryServiceFoundEvent(service: first),
    );
    await Future<void>.delayed(Duration.zero);
    expect(factory.discoveries.single.resolved, contains(first));
    factory.discoveries.single.emit(
      BonsoirDiscoveryServiceResolvedEvent(service: first),
    );
    factory.discoveries.single.emit(
      BonsoirDiscoveryServiceResolvedEvent(
        service: remote('second', '2001:db8::20'),
      ),
    );
    factory.discoveries.single.emit(
      BonsoirDiscoveryServiceResolvedEvent(
        service: remote('self', '192.168.1.10', id: localId),
      ),
    );
    expect(discovery.currentPeers, hasLength(1));
    expect(discovery.currentPeers.single.endpoints, hasLength(2));
    expect(discovery.currentPeers.single.advertisedName, 'Alex');
    await Future<void>.delayed(Duration.zero);
    expect(peers.last.single.advertisedFingerprint, remoteId.shortFingerprint);

    factory.discoveries.single.emit(
      BonsoirDiscoveryServiceLostEvent(service: first),
    );
    expect(discovery.currentPeers.single.endpoints, hasLength(1));
    expect(discovery.currentPeers.single.advertisedName, isNull);
    await discovery.stopBrowsing().timeout(const Duration(seconds: 2));
    await discovery.stopAdvertising().timeout(const Duration(seconds: 2));
    expect(discovery.currentPeers, isEmpty);
    expect(discovery.currentStatus.isActive, isFalse);
    expect(factory.discoveries.single.stops, 1);
    expect(factory.broadcasts.single.stops, 1);
    await subscription.cancel();
    await discovery.dispose().timeout(const Duration(seconds: 2));
  });

  test('renaming and interface changes restart fresh native actions', () async {
    final factory = _FakeActionFactory();
    var interfaces = <String>{'1:lan:192.168.1.10'};
    final discovery = BonsoirPeerDiscovery(
      actionFactory: factory,
      interfaceProbe: () async => interfaces,
      clock: () => now,
    );
    await discovery.advertise(
      profile: profile(1),
      port: 45873,
      capabilities: <String>{'text'},
    );
    await discovery.browse();
    await discovery.advertise(
      profile: profile(2, name: 'River'),
      port: 45873,
      capabilities: <String>{'text'},
    );
    expect(factory.broadcasts, hasLength(2));
    expect(factory.broadcasts.first.stops, 1);
    expect(factory.broadcasts.last.service.attributes['profile'], '2');
    expect(factory.broadcasts.last.service.attributes['name'], 'River');

    factory.discoveries.last.emit(
      BonsoirDiscoveryServiceResolvedEvent(
        service: remote('first', '192.168.1.20'),
      ),
    );
    expect(discovery.currentPeers, hasLength(1));
    interfaces = <String>{};
    await discovery.refreshNetwork();
    expect(discovery.currentPeers, isEmpty);
    expect(discovery.currentStatus.issue, DiscoveryIssue.noNetwork);
    expect(factory.discoveries.last.stops, 1);
    interfaces = <String>{'2:wifi:192.168.2.10'};
    await discovery.refreshNetwork();
    expect(factory.discoveries, hasLength(2));
    expect(factory.broadcasts, hasLength(3));
    expect(discovery.currentStatus.isActive, isTrue);
    await discovery.refreshNetwork(restart: true);
    expect(factory.discoveries, hasLength(3));
    expect(factory.broadcasts, hasLength(4));
    await discovery.dispose().timeout(const Duration(seconds: 2));
  });

  test(
    'interface probe failure clears stale peers and native actions',
    () async {
      final factory = _FakeActionFactory();
      var probeFails = false;
      final discovery = BonsoirPeerDiscovery(
        actionFactory: factory,
        interfaceProbe: () async {
          if (probeFails) throw StateError('probe unavailable');
          return <String>{'1:lan:192.168.1.10'};
        },
        clock: () => now,
      );
      await discovery.advertise(
        profile: profile(1),
        port: 45873,
        capabilities: <String>{'text'},
      );
      await discovery.browse();
      factory.discoveries.single.emit(
        BonsoirDiscoveryServiceResolvedEvent(
          service: remote('first', '192.168.1.20'),
        ),
      );
      expect(discovery.currentPeers, hasLength(1));
      probeFails = true;
      await discovery.refreshNetwork();
      expect(discovery.currentPeers, isEmpty);
      expect(discovery.currentStatus.issue, DiscoveryIssue.serviceUnavailable);
      expect(discovery.currentStatus.activeInterfaceCount, 0);
      expect(discovery.currentStatus.isActive, isFalse);
      await discovery.dispose();
    },
  );
}

final class _FakeActionFactory implements BonjourActionFactory {
  final discoveries = <_FakeDiscovery>[];
  final broadcasts = <_FakeBroadcast>[];

  @override
  BonjourDiscoveryAction discovery(String type) {
    final action = _FakeDiscovery();
    discoveries.add(action);
    return action;
  }

  @override
  BonjourBroadcastAction broadcast(BonsoirService service) {
    final action = _FakeBroadcast(service);
    broadcasts.add(action);
    return action;
  }
}

final class _FakeDiscovery implements BonjourDiscoveryAction {
  final controller = StreamController<BonsoirDiscoveryEvent>.broadcast(
    sync: true,
  );
  final resolved = <BonsoirService>[];
  int stops = 0;

  @override
  Stream<BonsoirDiscoveryEvent> get events => controller.stream;

  void emit(BonsoirDiscoveryEvent event) => controller.add(event);

  @override
  Future<void> initialize() async {}

  @override
  Future<void> start() async => emit(const BonsoirDiscoveryStartedEvent());

  @override
  Future<void> stop() async {
    stops++;
    await controller.close();
  }

  @override
  Future<void> resolve(BonsoirService service) async => resolved.add(service);
}

final class _FakeBroadcast implements BonjourBroadcastAction {
  _FakeBroadcast(this.service);

  final BonsoirService service;
  final controller = StreamController<BonsoirBroadcastEvent>.broadcast(
    sync: true,
  );
  int stops = 0;

  @override
  Stream<BonsoirBroadcastEvent> get events => controller.stream;

  @override
  Future<void> initialize() async {}

  @override
  Future<void> start() async =>
      controller.add(BonsoirBroadcastStartedEvent(service: service));

  @override
  Future<void> stop() async {
    stops++;
    await controller.close();
  }
}
