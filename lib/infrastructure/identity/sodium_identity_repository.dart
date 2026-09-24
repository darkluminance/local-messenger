import 'dart:async';
import 'dart:typed_data';

import 'package:local_messenger/domain/contracts.dart';
import 'package:local_messenger/domain/identity.dart';
import 'package:local_messenger/infrastructure/identity/private_identity_store.dart';
import 'package:local_messenger/infrastructure/persistence/app_database.dart';
import 'package:sodium/sodium.dart';

enum IdentityStorageFailureCode {
  missingPrivateIdentity,
  identityMismatch,
  corruptPrivateIdentity,
  alreadyExists,
  unavailable,
}

final class IdentityStorageException implements Exception {
  const IdentityStorageException(this.code, this.message, [this.cause]);

  final IdentityStorageFailureCode code;
  final String message;
  final Object? cause;

  @override
  String toString() => message;
}

final class SodiumIdentityRepository implements IdentityRepository {
  factory SodiumIdentityRepository({
    required Sodium sodium,
    required AppDatabase database,
    required PrivateIdentityStore privateStore,
  }) => SodiumIdentityRepository._(sodium, database, privateStore);

  SodiumIdentityRepository._(this._sodium, this._database, this._privateStore);

  final Sodium _sodium;
  final AppDatabase _database;
  final PrivateIdentityStore _privateStore;

  @override
  Stream<LocalIdentity?> watchIdentity() => _database.watchLocalProfile().map(
    (IdentityProfile? profile) =>
        profile == null ? null : LocalIdentity(profile),
  );

  @override
  Future<LocalIdentity?> load() async {
    try {
      final envelope = await _privateStore.read();
      final databaseProfile = await _database.readLocalProfile();
      if (envelope == null && databaseProfile == null) {
        return null;
      }
      if (envelope == null) {
        throw const IdentityStorageException(
          IdentityStorageFailureCode.missingPrivateIdentity,
          'The public profile exists, but its private identity is unavailable.',
        );
      }
      final secureProfile = _profileFromEnvelope(envelope);
      if (databaseProfile == null) {
        await _database.saveLocalProfile(secureProfile);
        return LocalIdentity(secureProfile);
      }
      if (databaseProfile.deviceId != secureProfile.deviceId ||
          databaseProfile.publicKey != secureProfile.publicKey) {
        throw const IdentityStorageException(
          IdentityStorageFailureCode.identityMismatch,
          'Secure identity and local profile do not match.',
        );
      }
      if (secureProfile.revision > databaseProfile.revision ||
          (secureProfile.revision == databaseProfile.revision &&
              secureProfile.displayName != databaseProfile.displayName)) {
        await _database.saveLocalProfile(secureProfile);
        return LocalIdentity(secureProfile);
      }
      if (databaseProfile.revision > secureProfile.revision) {
        await _privateStore.write(
          _envelopeFromProfile(databaseProfile, envelope.secretKey),
        );
      }
      return LocalIdentity(databaseProfile);
    } on IdentityStorageException {
      rethrow;
    } on FormatException catch (error) {
      throw IdentityStorageException(
        IdentityStorageFailureCode.corruptPrivateIdentity,
        'The secure identity record is unreadable.',
        error,
      );
    } catch (error) {
      throw IdentityStorageException(
        IdentityStorageFailureCode.unavailable,
        'Secure identity storage is unavailable.',
        error,
      );
    }
  }

  @override
  Future<LocalIdentity> create(DisplayName displayName) async {
    if (await _privateStore.read() != null ||
        await _database.readLocalProfile() != null) {
      throw const IdentityStorageException(
        IdentityStorageFailureCode.alreadyExists,
        'An installation identity already exists.',
      );
    }
    final keyPair = _sodium.crypto.sign.keyPair();
    final secretBytes = keyPair.secretKey.extractBytes();
    try {
      final now = DateTime.now().toUtc();
      final profile = IdentityProfile(
        deviceId: DeviceId.fromPublicKey(PublicKeyBytes(keyPair.publicKey)),
        publicKey: PublicKeyBytes(keyPair.publicKey),
        displayName: displayName,
        revision: 1,
        createdAt: now,
        updatedAt: now,
      );
      await _privateStore.write(_envelopeFromProfile(profile, secretBytes));
      await _database.saveLocalProfile(profile);
      return LocalIdentity(profile);
    } finally {
      secretBytes.fillRange(0, secretBytes.length, 0);
      keyPair.dispose();
    }
  }

  @override
  Future<LocalIdentity> updateDisplayName(DisplayName displayName) async {
    final current = await load();
    if (current == null) {
      throw const IdentityStorageException(
        IdentityStorageFailureCode.missingPrivateIdentity,
        'Create an identity before changing its display name.',
      );
    }
    final envelope = await _readRequiredEnvelope();
    final updated = IdentityProfile(
      deviceId: current.deviceId,
      publicKey: current.publicKey,
      displayName: displayName,
      revision: current.revision + 1,
      createdAt: current.profile.createdAt,
      updatedAt: DateTime.now().toUtc(),
    );
    await _privateStore.write(
      _envelopeFromProfile(updated, envelope.secretKey),
    );
    await _database.saveLocalProfile(updated);
    return LocalIdentity(updated);
  }

  @override
  Future<Uint8List> sign(Uint8List message) async {
    final envelope = await _readRequiredEnvelope();
    final secretBytes = Uint8List.fromList(envelope.secretKey);
    final secretKey = SecureKey.fromList(_sodium, secretBytes);
    try {
      return _sodium.crypto.sign.detached(
        message: message,
        secretKey: secretKey,
      );
    } finally {
      secretKey.dispose();
      secretBytes.fillRange(0, secretBytes.length, 0);
    }
  }

  Future<PrivateIdentityEnvelope> _readRequiredEnvelope() async {
    final envelope = await _privateStore.read();
    if (envelope == null) {
      throw const IdentityStorageException(
        IdentityStorageFailureCode.missingPrivateIdentity,
        'The private installation identity is unavailable.',
      );
    }
    return envelope;
  }

  IdentityProfile _profileFromEnvelope(PrivateIdentityEnvelope envelope) {
    final publicKey = PublicKeyBytes(envelope.publicKey);
    if (envelope.secretKey.length != _sodium.crypto.sign.secretKeyBytes) {
      throw const FormatException('Unexpected Ed25519 secret-key length.');
    }
    final secretBytes = envelope.secretKey;
    final secretKey = SecureKey.fromList(_sodium, secretBytes);
    try {
      final challenge = Uint8List.fromList(const <int>[108, 111, 99, 97, 108]);
      final signature = _sodium.crypto.sign.detached(
        message: challenge,
        secretKey: secretKey,
      );
      if (!_sodium.crypto.sign.verifyDetached(
        message: challenge,
        signature: signature,
        publicKey: publicKey.bytes,
      )) {
        throw const FormatException('Ed25519 key pair does not match.');
      }
    } finally {
      secretKey.dispose();
      secretBytes.fillRange(0, secretBytes.length, 0);
    }
    return IdentityProfile(
      deviceId: DeviceId.fromPublicKey(publicKey),
      publicKey: publicKey,
      displayName: DisplayName.parse(envelope.displayName),
      revision: envelope.profileRevision,
      createdAt: DateTime.fromMicrosecondsSinceEpoch(
        envelope.createdAtMicros,
        isUtc: true,
      ),
      updatedAt: DateTime.fromMicrosecondsSinceEpoch(
        envelope.updatedAtMicros,
        isUtc: true,
      ),
    );
  }

  static PrivateIdentityEnvelope _envelopeFromProfile(
    IdentityProfile profile,
    List<int> secretKey,
  ) => PrivateIdentityEnvelope(
    publicKey: profile.publicKey.bytes,
    secretKey: Uint8List.fromList(secretKey),
    displayName: profile.displayName.value,
    profileRevision: profile.revision,
    createdAtMicros: profile.createdAt.toUtc().microsecondsSinceEpoch,
    updatedAtMicros: profile.updatedAt.toUtc().microsecondsSinceEpoch,
  );
}
