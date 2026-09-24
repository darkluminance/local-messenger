import 'package:flutter_test/flutter_test.dart';
import 'package:local_messenger/domain/contracts.dart';
import 'package:local_messenger/domain/identity.dart';
import 'package:local_messenger/infrastructure/discovery/presence_registry.dart';

void main() {
  final localId = DeviceId(List<int>.filled(32, 1));
  final remoteId = DeviceId(List<int>.filled(32, 2));
  final now = DateTime.utc(2026, 9, 23);

  Map<String, String> txt(DeviceId deviceId) => <String, String>{
    'v': '1.0',
    'id': deviceId.hex,
    'caps': 'text',
    'profile': '1',
  };

  DiscoveryRecord? parse(
    String name,
    DeviceId id, {
    List<String> addresses = const <String>['192.168.1.20'],
    Map<String, String>? attributes,
  }) => DiscoveryRecord.parse(
    serviceName: name,
    type: '_localmsg._tcp',
    port: 45873,
    attributes: attributes ?? txt(id),
    hostAddresses: addresses,
  );

  test('TXT parser rejects malformed or unsupported advertisements', () {
    expect(parse('remote', remoteId), isNotNull);
    expect(
      parse(
        'remote',
        remoteId,
        attributes: <String, String>{...txt(remoteId), 'v': '2.0'},
      ),
      isNull,
    );
    expect(
      parse(
        'remote',
        remoteId,
        attributes: <String, String>{...txt(remoteId), 'id': 'not-a-device-id'},
      ),
      isNull,
    );
    expect(
      parse(
        'remote',
        remoteId,
        attributes: <String, String>{...txt(remoteId), 'name': 'Alex'},
      )?.advertisedName,
      'Alex',
    );
    expect(
      parse(
        'remote',
        remoteId,
        attributes: <String, String>{...txt(remoteId), 'extra': 'unknown'},
      ),
      isNull,
    );
    expect(
      parse('remote', remoteId, addresses: const <String>['peer.local']),
      isNull,
    );
  });

  test('optional TXT name is bounded and malformed hints fall back safely', () {
    expect(parse('legacy', remoteId)?.advertisedName, isNull);
    final unicode = 'A' * 62 + 'é';
    expect(
      parse(
        'unicode',
        remoteId,
        attributes: <String, String>{...txt(remoteId), 'name': unicode},
      )?.advertisedName,
      unicode,
    );
    for (final invalid in <String>[
      '',
      ' padded ',
      'A' * 65,
      'line\nbreak',
      'spoof\u202e',
      'isolate\u2066',
      'separator\u2028',
    ]) {
      final record = parse(
        'invalid',
        remoteId,
        attributes: <String, String>{...txt(remoteId), 'name': invalid},
      );
      expect(record, isNotNull);
      expect(record!.advertisedName, isNull);
    }
  });

  test(
    'highest profile revision supplies unverified name without duplication',
    () {
      final registry = PresenceRegistry(localDeviceId: localId);
      final old = parse(
        'old',
        remoteId,
        attributes: <String, String>{...txt(remoteId), 'name': 'Alex'},
      )!;
      final renamed = parse(
        'new',
        remoteId,
        addresses: const <String>['2001:db8::20'],
        attributes: <String, String>{
          ...txt(remoteId),
          'profile': '2',
          'name': 'River',
        },
      )!;
      registry.observe(old, now);
      registry.observe(renamed, now);
      expect(registry.peers, hasLength(1));
      expect(registry.peers.single.advertisedName, 'River');
      expect(registry.peers.single.profileRevision, 2);
      registry.lose('new');
      expect(registry.peers.single.advertisedName, 'Alex');
      registry.observe(
        parse(
          'old',
          remoteId,
          attributes: <String, String>{
            ...txt(remoteId),
            'profile': '3',
            'name': 'Morgan',
          },
        )!,
        now,
      );
      expect(registry.peers.single.advertisedName, 'Morgan');
      expect(registry.peers, hasLength(1));
    },
  );

  test('preserves IPv4, IPv6, and scoped link-local candidates', () {
    final record = parse(
      'remote',
      remoteId,
      addresses: const <String>[
        '192.168.1.20',
        '2001:db8::20',
        'fe80::20%en0',
        'fe80::21',
        'peer.local',
        '127.0.0.1',
      ],
    )!;
    expect(
      record.endpoints.map((endpoint) => endpoint.address),
      containsAll(<String>['192.168.1.20', '2001:db8::20', 'fe80::20%en0']),
    );
    expect(record.endpoints, hasLength(3));
  });

  test('deduplicates multi-service presence and ignores self', () {
    final registry = PresenceRegistry(localDeviceId: localId);
    expect(registry.observe(parse('self', localId)!, now), isFalse);
    expect(registry.peers, isEmpty);

    registry.observe(parse('remote-a', remoteId)!, now);
    registry.observe(
      parse('remote-b', remoteId, addresses: const <String>['2001:db8::20'])!,
      now,
    );
    expect(registry.peers, hasLength(1));
    expect(registry.peers.single.endpoints, hasLength(2));
    expect(
      registry.peers.single.advertisedFingerprint,
      remoteId.shortFingerprint,
    );

    registry.lose('remote-a');
    expect(registry.peers.single.endpoints, hasLength(1));
  });

  test('lost, stale, and reappearing records reconcile', () {
    final registry = PresenceRegistry(
      localDeviceId: localId,
      lifetime: const Duration(seconds: 10),
    );
    registry.observe(parse('remote', remoteId)!, now);
    expect(registry.peers, hasLength(1));
    expect(registry.expire(now.add(const Duration(seconds: 11))), isTrue);
    expect(registry.peers, isEmpty);

    registry.observe(
      parse('remote', remoteId)!,
      now.add(const Duration(seconds: 12)),
    );
    expect(registry.peers, hasLength(1));
    expect(registry.lose('remote'), isTrue);
    expect(registry.peers, isEmpty);
  });

  test('updated service replaces removed addresses immediately', () {
    final registry = PresenceRegistry(localDeviceId: localId);
    registry.observe(
      parse(
        'remote',
        remoteId,
        addresses: const <String>['192.168.1.20', '2001:db8::20'],
      )!,
      now,
    );
    expect(registry.peers.single.endpoints, hasLength(2));
    expect(
      registry.observe(
        parse('remote', remoteId, addresses: const <String>['192.168.1.20'])!,
        now,
      ),
      isTrue,
    );
    expect(registry.peers.single.endpoints, hasLength(1));
  });

  test('untrusted observations stay bounded', () {
    final registry = PresenceRegistry(localDeviceId: localId);
    for (var number = 2; number < 100; number++) {
      registry.observe(
        parse('service-$number', DeviceId(List<int>.filled(32, number)))!,
        now.add(Duration(milliseconds: number)),
      );
    }
    var removed = 0;
    for (var number = 2; number < 100; number++) {
      if (registry.lose('service-$number')) removed++;
    }
    expect(removed, maximumStoredObservations);
  });

  test('visible presence stays bounded to ten advertised devices', () {
    final registry = PresenceRegistry(localDeviceId: localId);
    for (var number = 2; number < 20; number++) {
      final id = DeviceId(List<int>.filled(32, number));
      registry.observe(parse('peer-$number', id)!, now);
    }
    expect(registry.peers, hasLength(maximumVisiblePeers));
    expect(
      registry.peers.every((PeerPresence peer) => peer.isAvailable),
      isTrue,
    );
  });
}
