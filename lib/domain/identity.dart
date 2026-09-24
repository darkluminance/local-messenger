import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:local_messenger/domain/bytes.dart';

const int maximumDisplayNameBytes = 64;

final class DisplayNameValidationException implements Exception {
  const DisplayNameValidationException(this.message);

  final String message;

  @override
  String toString() => message;
}

final class DisplayName {
  DisplayName._(this.value);

  factory DisplayName.parse(String input) {
    final value = input.trim();
    if (value.isEmpty) {
      throw const DisplayNameValidationException('Enter a display name.');
    }
    if (input.runes.any(
      (rune) =>
          rune < 0x20 ||
          (rune >= 0x7f && rune <= 0x9f) ||
          rune == 0x061c ||
          rune == 0x200e ||
          rune == 0x200f ||
          (rune >= 0x2028 && rune <= 0x202e) ||
          (rune >= 0x2066 && rune <= 0x2069),
    )) {
      throw const DisplayNameValidationException(
        'Display names cannot contain control characters, line breaks, or direction controls.',
      );
    }
    if (utf8.encode(value).length > maximumDisplayNameBytes) {
      throw const DisplayNameValidationException(
        'Display names must be 64 UTF-8 bytes or fewer.',
      );
    }
    return DisplayName._(value);
  }

  final String value;

  @override
  bool operator ==(Object other) =>
      other is DisplayName && other.value == value;

  @override
  int get hashCode => value.hashCode;

  @override
  String toString() => value;
}

final class PublicKeyBytes extends FixedBytes {
  PublicKeyBytes(super.bytes) : super(length: 32);
}

final class DeviceId extends FixedBytes {
  DeviceId(super.bytes) : super(length: 32);

  factory DeviceId.fromPublicKey(PublicKeyBytes publicKey) =>
      DeviceId(sha256.convert(publicKey.bytes).bytes);

  String get shortFingerprint => hex.substring(0, 12).toUpperCase();
}

final class IdentityProfile {
  const IdentityProfile({
    required this.deviceId,
    required this.publicKey,
    required this.displayName,
    required this.revision,
    required this.createdAt,
    required this.updatedAt,
  });

  final DeviceId deviceId;
  final PublicKeyBytes publicKey;
  final DisplayName displayName;
  final int revision;
  final DateTime createdAt;
  final DateTime updatedAt;

  String get shortFingerprint => deviceId.shortFingerprint;
}

final class LocalIdentity {
  const LocalIdentity(this.profile);

  final IdentityProfile profile;

  DeviceId get deviceId => profile.deviceId;
  PublicKeyBytes get publicKey => profile.publicKey;
  DisplayName get displayName => profile.displayName;
  int get revision => profile.revision;
  String get shortFingerprint => profile.shortFingerprint;
}

final class PinnedPeer {
  const PinnedPeer({
    required this.profile,
    required this.pinnedAt,
    required this.lastVerifiedAt,
    required this.trustState,
  });

  final IdentityProfile profile;
  final DateTime pinnedAt;
  final DateTime lastVerifiedAt;
  final PeerTrustState trustState;
}

enum PeerTrustState { trusted, quarantined }
