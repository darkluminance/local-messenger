import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:local_messenger/domain/contracts.dart';
import 'package:local_messenger/domain/identity.dart';
import 'package:local_messenger/phase0/constants.dart';

enum AppStage { loading, onboarding, ready, identityFailure }

final class AppController extends ChangeNotifier {
  factory AppController(
    IdentityRepository identityRepository, {
    PeerDiscovery? discovery,
  }) => AppController._(identityRepository, discovery);

  AppController._(this._identityRepository, this._discovery);

  final IdentityRepository _identityRepository;
  final PeerDiscovery? _discovery;
  StreamSubscription<List<PeerPresence>>? _peersSubscription;
  StreamSubscription<DiscoveryStatus>? _statusSubscription;
  Future<void>? _startingDiscovery;
  Future<void>? _updatingAdvertisement;
  bool _stopRequested = false;
  bool _disposed = false;

  AppStage _stage = AppStage.loading;
  LocalIdentity? _identity;
  String? _identityFailureMessage;
  String? _onboardingError;
  String? _settingsError;
  bool _isWorking = false;
  List<PeerPresence> _nearbyPeers = const <PeerPresence>[];
  DiscoveryStatus _discoveryStatus = const DiscoveryStatus(
    advertising: false,
    browsing: false,
    activeInterfaceCount: 0,
    issue: DiscoveryIssue.none,
  );

  AppStage get stage => _stage;
  LocalIdentity? get identity => _identity;
  String? get identityFailureMessage => _identityFailureMessage;
  String? get onboardingError => _onboardingError;
  String? get settingsError => _settingsError;
  bool get isWorking => _isWorking;
  List<PeerPresence> get nearbyPeers => _nearbyPeers;
  DiscoveryStatus get discoveryStatus => _discoveryStatus;

  Future<void> initialize() async {
    _stage = AppStage.loading;
    _identityFailureMessage = null;
    _onboardingError = null;
    _settingsError = null;
    notifyListeners();
    try {
      final identity = await _identityRepository.load();
      if (_disposed) return;
      _identity = identity;
      _stage = identity == null ? AppStage.onboarding : AppStage.ready;
      if (identity != null) {
        _stopRequested = false;
        unawaited(_startingDiscovery = _startDiscovery(identity));
      }
    } catch (_) {
      if (_disposed) return;
      _setIdentityFailure('Local identity storage could not be opened.');
    }
    if (!_disposed) notifyListeners();
  }

  Future<bool> createIdentity(String input) async {
    if (_isWorking) return false;
    final displayName = _parseDisplayName(input, onboarding: true);
    if (displayName == null) return false;

    _setWorking(true);
    try {
      _identity = await _identityRepository.create(displayName);
      if (_disposed) return false;
      _onboardingError = null;
      _stage = AppStage.ready;
      _stopRequested = false;
      unawaited(_startingDiscovery = _startDiscovery(_identity!));
      return true;
    } catch (_) {
      _setIdentityFailure('The installation identity could not be created.');
      return false;
    } finally {
      _setWorking(false);
    }
  }

  Future<bool> updateDisplayName(String input) async {
    if (_isWorking) return false;
    final displayName = _parseDisplayName(input, onboarding: false);
    if (displayName == null) return false;

    _setWorking(true);
    try {
      _identity = await _identityRepository.updateDisplayName(displayName);
      if (_discovery != null && !_stopRequested && !_disposed) {
        try {
          await (_updatingAdvertisement = _discovery.advertise(
            profile: _identity!.profile,
            port: localMessengerDefaultPort,
            capabilities: const <String>{'text'},
          ));
        } catch (_) {
          _discoveryStatus = const DiscoveryStatus(
            advertising: false,
            browsing: false,
            activeInterfaceCount: 0,
            issue: DiscoveryIssue.interrupted,
            detail: 'The updated name revision could not be advertised.',
          );
        }
        _updatingAdvertisement = null;
      }
      _settingsError = null;
      notifyListeners();
      return true;
    } catch (_) {
      _settingsError = 'The display name could not be saved.';
      notifyListeners();
      return false;
    } finally {
      _setWorking(false);
    }
  }

  DisplayName? _parseDisplayName(String input, {required bool onboarding}) {
    try {
      final displayName = DisplayName.parse(input);
      if (onboarding) {
        _onboardingError = null;
      } else {
        _settingsError = null;
      }
      return displayName;
    } on DisplayNameValidationException catch (error) {
      if (onboarding) {
        _onboardingError = error.message;
      } else {
        _settingsError = error.message;
      }
      notifyListeners();
      return null;
    }
  }

  void _setIdentityFailure(String message) {
    _identity = null;
    _identityFailureMessage = message;
    _stage = AppStage.identityFailure;
  }

  void _setWorking(bool value) {
    _isWorking = value;
    if (!_disposed) notifyListeners();
  }

  Future<void> _startDiscovery(LocalIdentity identity) async {
    final discovery = _discovery;
    if (discovery == null || _stopRequested || _disposed) {
      return;
    }
    await _peersSubscription?.cancel();
    await _statusSubscription?.cancel();
    if (_stopRequested || _disposed) return;
    _peersSubscription = discovery.watchPeers().listen((peers) {
      if (_disposed) return;
      _nearbyPeers = peers;
      notifyListeners();
    });
    _statusSubscription = discovery.watchStatus().listen((status) {
      if (_disposed) return;
      _discoveryStatus = status;
      notifyListeners();
    });
    try {
      if (_stopRequested || _disposed) return;
      await discovery.advertise(
        profile: identity.profile,
        port: localMessengerDefaultPort,
        capabilities: const <String>{'text'},
      );
      if (!_stopRequested && !_disposed) await discovery.browse();
    } catch (_) {
      _discoveryStatus = const DiscoveryStatus(
        advertising: false,
        browsing: false,
        activeInterfaceCount: 0,
        issue: DiscoveryIssue.serviceUnavailable,
        detail: 'Local discovery could not start.',
      );
      if (!_disposed) notifyListeners();
    }
  }

  Future<void> stopDiscovery() async {
    _stopRequested = true;
    await _startingDiscovery;
    await _updatingAdvertisement;
    await _peersSubscription?.cancel();
    await _statusSubscription?.cancel();
    _peersSubscription = null;
    _statusSubscription = null;
    await _discovery?.stopBrowsing();
    await _discovery?.stopAdvertising();
    _nearbyPeers = const <PeerPresence>[];
    if (!_disposed) notifyListeners();
  }

  Future<void> refreshDiscoveryAfterResume() async {
    if (_disposed || _stopRequested || _stage != AppStage.ready) return;
    try {
      await _discovery?.refreshNetwork(restart: true);
    } catch (_) {
      if (_disposed) return;
      _discoveryStatus = const DiscoveryStatus(
        advertising: false,
        browsing: false,
        activeInterfaceCount: 0,
        issue: DiscoveryIssue.interrupted,
        detail: 'Could not restart discovery after resuming.',
      );
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _disposed = true;
    unawaited(stopDiscovery());
    super.dispose();
  }
}
