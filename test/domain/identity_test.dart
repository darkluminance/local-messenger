import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:local_messenger/domain/identity.dart';

void main() {
  group('DisplayName', () {
    test('trims presentation whitespace once', () {
      expect(DisplayName.parse('  Raiyan  ').value, 'Raiyan');
    });

    test('rejects empty, control, and oversized values', () {
      expect(
        () => DisplayName.parse('  '),
        throwsA(isA<DisplayNameValidationException>()),
      );
      expect(
        () => DisplayName.parse('line\nbreak'),
        throwsA(isA<DisplayNameValidationException>()),
      );
      expect(
        () => DisplayName.parse('é' * 33),
        throwsA(isA<DisplayNameValidationException>()),
      );
      expect(
        () => DisplayName.parse('spoof\u202e'),
        throwsA(isA<DisplayNameValidationException>()),
      );
      expect(
        () => DisplayName.parse('separator\u2028'),
        throwsA(isA<DisplayNameValidationException>()),
      );
      expect(DisplayName.parse('রায়ান').value, 'রায়ান');
    });
  });

  test(
    'device identity is derived from public bytes with a short fingerprint',
    () {
      final first = DeviceId.fromPublicKey(PublicKeyBytes(Uint8List(32)));
      final second = DeviceId.fromPublicKey(
        PublicKeyBytes(
          Uint8List.fromList(<int>[1, ...List<int>.filled(31, 0)]),
        ),
      );

      expect(first.bytes, hasLength(32));
      expect(first.shortFingerprint, hasLength(12));
      expect(first.shortFingerprint, isNot(second.shortFingerprint));
    },
  );

  test('duplicate display names remain distinct by fingerprint', () {
    final name = DisplayName.parse('Alex');
    final first = IdentityProfile(
      deviceId: DeviceId(List<int>.filled(32, 1)),
      publicKey: PublicKeyBytes(List<int>.filled(32, 1)),
      displayName: name,
      revision: 1,
      createdAt: DateTime.utc(2026),
      updatedAt: DateTime.utc(2026),
    );
    final second = IdentityProfile(
      deviceId: DeviceId(List<int>.filled(32, 2)),
      publicKey: PublicKeyBytes(List<int>.filled(32, 2)),
      displayName: name,
      revision: 1,
      createdAt: DateTime.utc(2026),
      updatedAt: DateTime.utc(2026),
    );

    expect(first.displayName, second.displayName);
    expect(first.shortFingerprint, isNot(second.shortFingerprint));
  });
}
