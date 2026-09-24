import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:local_messenger/application/app_controller.dart';
import 'package:local_messenger/domain/contracts.dart';
import 'package:local_messenger/domain/identity.dart';
import 'package:local_messenger/presentation/local_messenger_app.dart';

void main() {
  test('stop waits for in-flight startup and prevents late browsing', () async {
    final repository = _FakeIdentityRepository()
      ..identity = _identity(DisplayName.parse('River'));
    final discovery = _FakePeerDiscovery()..advertiseGate = Completer<void>();
    final controller = AppController(repository, discovery: discovery);
    await controller.initialize();
    await Future<void>.delayed(Duration.zero);
    final stopping = controller.stopDiscovery();
    discovery.advertiseGate!.complete();
    await stopping.timeout(const Duration(seconds: 2));
    expect(discovery.browseCalls, 0);
    expect(discovery.stopBrowsingCalls, 1);
    expect(discovery.stopAdvertisingCalls, 1);
    controller.dispose();
  });

  testWidgets('onboards into the mobile Phase 1 shell', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final repository = _FakeIdentityRepository();
    final controller = AppController(repository);
    await controller.initialize();

    await tester.pumpWidget(LocalMessengerApp(controller: controller));
    expect(find.text('Your corner of the local network'), findsOneWidget);
    expect(find.text('Create local identity'), findsOneWidget);

    await tester.enterText(find.byType(TextField), 'River');
    await tester.tap(find.text('Create local identity'));
    await tester.pumpAndSettle();

    expect(find.byType(NavigationBar), findsOneWidget);
    expect(find.text('Nearby'), findsWidgets);
    expect(find.text('Local discovery is not running'), findsOneWidget);
  });

  testWidgets('uses a navigation rail on a wide window', (
    WidgetTester tester,
  ) async {
    final repository = _FakeIdentityRepository()
      ..identity = _identity(DisplayName.parse('River'));
    final controller = AppController(repository);
    await controller.initialize();

    await tester.pumpWidget(LocalMessengerApp(controller: controller));
    await tester.pump();

    expect(find.byType(NavigationRail), findsOneWidget);
    expect(find.text('Local discovery is not running'), findsOneWidget);
  });

  testWidgets('shows unverified peers and live discovery diagnostics', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final repository = _FakeIdentityRepository()
      ..identity = _identity(DisplayName.parse('River'));
    final discovery = _FakePeerDiscovery();
    final controller = AppController(repository, discovery: discovery);
    await controller.initialize();
    await tester.pumpWidget(LocalMessengerApp(controller: controller));
    await tester.pumpAndSettle();

    final remoteId = DeviceId(List<int>.filled(32, 9));
    discovery.emitStatus(
      const DiscoveryStatus(
        advertising: true,
        browsing: true,
        activeInterfaceCount: 1,
        issue: DiscoveryIssue.none,
      ),
    );
    discovery.emitPeers(<PeerPresence>[
      PeerPresence(
        deviceId: remoteId,
        isAvailable: true,
        endpoints: const <PeerEndpoint>[
          PeerEndpoint(address: '192.168.1.9', port: 45873),
        ],
        profileRevision: 1,
        advertisedName: 'Alex',
      ),
    ]);
    await tester.pumpAndSettle();

    expect(find.text(remoteId.shortFingerprint), findsOneWidget);
    expect(find.text('Alex'), findsOneWidget);
    expect(find.text('Unverified'), findsOneWidget);
    expect(find.text('Start conversation'), findsNothing);

    discovery.emitPeers(<PeerPresence>[
      PeerPresence(
        deviceId: remoteId,
        isAvailable: true,
        endpoints: const <PeerEndpoint>[
          PeerEndpoint(address: '192.168.1.9', port: 45873),
        ],
        profileRevision: 1,
      ),
    ]);
    await tester.pumpAndSettle();
    expect(find.text('Nearby device'), findsOneWidget);
    expect(find.text(remoteId.shortFingerprint), findsOneWidget);

    await tester.tap(find.text('Diagnostics').last);
    await tester.pumpAndSettle();
    expect(find.text('Advertising and scanning'), findsOneWidget);
    expect(find.text('1 unverified'), findsOneWidget);
    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
    await tester.pump();
    expect(discovery.refreshCalls, 1);
  });

  testWidgets('duplicate names render with distinct fingerprints', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: Column(
            children: <Widget>[
              IdentityLabel(displayName: 'Alex', fingerprint: '111111111111'),
              IdentityLabel(displayName: 'Alex', fingerprint: '222222222222'),
            ],
          ),
        ),
      ),
    );

    expect(find.text('Alex'), findsNWidgets(2));
    expect(find.text('111111111111'), findsOneWidget);
    expect(find.text('222222222222'), findsOneWidget);
  });

  testWidgets(
    'Android notification permission is optional and user-initiated',
    (WidgetTester tester) async {
      debugDefaultTargetPlatformOverride = TargetPlatform.android;
      const channel = MethodChannel('dev.localmessenger.app/permissions');
      var requested = false;
      tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(channel, (
        call,
      ) async {
        if (call.method == 'notificationStatus') return false;
        if (call.method == 'requestNotifications') {
          requested = true;
          return true;
        }
        return null;
      });
      addTearDown(
        () => tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
          channel,
          null,
        ),
      );
      final repository = _FakeIdentityRepository()
        ..identity = _identity(DisplayName.parse('River'));
      final controller = AppController(
        repository,
        discovery: _FakePeerDiscovery(),
      );
      await controller.initialize();
      await tester.pumpWidget(LocalMessengerApp(controller: controller));
      await tester.tap(find.text('Diagnostics').last);
      await tester.pumpAndSettle();
      expect(find.text('Not allowed'), findsOneWidget);
      expect(requested, isFalse);
      await tester.tap(find.text('Allow notifications'));
      await tester.pumpAndSettle();
      expect(requested, isTrue);
      expect(find.text('Allowed'), findsOneWidget);
      debugDefaultTargetPlatformOverride = null;
    },
  );
}

final class _FakeIdentityRepository implements IdentityRepository {
  LocalIdentity? identity;

  @override
  Future<LocalIdentity> create(DisplayName displayName) async {
    identity = _identity(displayName);
    return identity!;
  }

  @override
  Future<LocalIdentity?> load() async => identity;

  @override
  Future<Uint8List> sign(Uint8List message) async => Uint8List(64);

  @override
  Future<LocalIdentity> updateDisplayName(DisplayName displayName) async {
    identity = _identity(displayName, revision: (identity?.revision ?? 0) + 1);
    return identity!;
  }

  @override
  Stream<LocalIdentity?> watchIdentity() => Stream.value(identity);
}

final class _FakePeerDiscovery implements PeerDiscovery {
  Completer<void>? advertiseGate;
  int browseCalls = 0;
  int stopBrowsingCalls = 0;
  int stopAdvertisingCalls = 0;
  int refreshCalls = 0;
  final StreamController<List<PeerPresence>> _peers =
      StreamController<List<PeerPresence>>.broadcast();
  final StreamController<DiscoveryStatus> _status =
      StreamController<DiscoveryStatus>.broadcast();
  List<PeerPresence> _currentPeers = const <PeerPresence>[];
  DiscoveryStatus _currentStatus = const DiscoveryStatus(
    advertising: false,
    browsing: false,
    activeInterfaceCount: 0,
    issue: DiscoveryIssue.none,
  );

  void emitPeers(List<PeerPresence> peers) {
    _currentPeers = peers;
    _peers.add(peers);
  }

  void emitStatus(DiscoveryStatus status) {
    _currentStatus = status;
    _status.add(status);
  }

  @override
  Stream<List<PeerPresence>> watchPeers() =>
      Stream<List<PeerPresence>>.multi((controller) {
        controller.add(_currentPeers);
        final subscription = _peers.stream.listen(controller.add);
        controller.onCancel = subscription.cancel;
      });

  @override
  Stream<DiscoveryStatus> watchStatus() =>
      Stream<DiscoveryStatus>.multi((controller) {
        controller.add(_currentStatus);
        final subscription = _status.stream.listen(controller.add);
        controller.onCancel = subscription.cancel;
      });

  @override
  Future<void> advertise({
    required IdentityProfile profile,
    required int port,
    required Set<String> capabilities,
  }) async {
    await advertiseGate?.future;
  }

  @override
  Future<void> browse() async {
    browseCalls++;
  }

  @override
  Future<void> refreshNetwork({bool restart = false}) async {
    if (restart) refreshCalls++;
  }

  @override
  Future<void> stopAdvertising() async {
    stopAdvertisingCalls++;
  }

  @override
  Future<void> stopBrowsing() async {
    stopBrowsingCalls++;
  }
}

LocalIdentity _identity(DisplayName displayName, {int revision = 1}) {
  final now = DateTime.utc(2026, 9, 23);
  final publicKey = PublicKeyBytes(List<int>.generate(32, (index) => index));
  return LocalIdentity(
    IdentityProfile(
      deviceId: DeviceId.fromPublicKey(publicKey),
      publicKey: publicKey,
      displayName: displayName,
      revision: revision,
      createdAt: now,
      updatedAt: now,
    ),
  );
}
