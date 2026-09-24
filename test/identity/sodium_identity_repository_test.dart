import 'dart:typed_data';

import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:local_messenger/domain/identity.dart';
import 'package:local_messenger/infrastructure/identity/private_identity_store.dart';
import 'package:local_messenger/infrastructure/identity/sodium_identity_repository.dart';
import 'package:local_messenger/infrastructure/persistence/app_database.dart';
import 'package:sodium/sodium.dart';

void main() {
  late Sodium sodium;

  setUpAll(() async {
    sodium = await SodiumInit.init();
  });

  test('identity survives repository restart and name changes', () async {
    final database = AppDatabase(NativeDatabase.memory());
    final secureStore = MemoryPrivateIdentityStore();
    final repository = SodiumIdentityRepository(
      sodium: sodium,
      database: database,
      privateStore: secureStore,
    );
    final created = await repository.create(DisplayName.parse('Raiyan'));
    final restarted = SodiumIdentityRepository(
      sodium: sodium,
      database: database,
      privateStore: secureStore,
    );

    final loaded = await restarted.load();
    final renamed = await restarted.updateDisplayName(DisplayName.parse('Ray'));

    expect(loaded!.deviceId, created.deviceId);
    expect(renamed.deviceId, created.deviceId);
    expect(renamed.publicKey, created.publicKey);
    expect(renamed.revision, 2);
    expect(renamed.displayName.value, 'Ray');
    await database.close();
  });

  test(
    'secure-only interrupted bootstrap reconstructs public metadata',
    () async {
      final firstDatabase = AppDatabase(NativeDatabase.memory());
      final secureStore = MemoryPrivateIdentityStore();
      final firstRepository = SodiumIdentityRepository(
        sodium: sodium,
        database: firstDatabase,
        privateStore: secureStore,
      );
      final created = await firstRepository.create(DisplayName.parse('Raiyan'));
      await firstDatabase.close();

      final emptyDatabase = AppDatabase(NativeDatabase.memory());
      final recovered = await SodiumIdentityRepository(
        sodium: sodium,
        database: emptyDatabase,
        privateStore: secureStore,
      ).load();

      expect(recovered!.deviceId, created.deviceId);
      expect(
        (await emptyDatabase.readLocalProfile())!.deviceId,
        created.deviceId,
      );
      await emptyDatabase.close();
    },
  );

  test('database-only identity fails closed', () async {
    final database = AppDatabase(NativeDatabase.memory());
    final now = DateTime.utc(2026);
    final publicKey = PublicKeyBytes(Uint8List(32));
    await database.saveLocalProfile(
      IdentityProfile(
        deviceId: DeviceId.fromPublicKey(publicKey),
        publicKey: publicKey,
        displayName: DisplayName.parse('Raiyan'),
        revision: 1,
        createdAt: now,
        updatedAt: now,
      ),
    );

    expect(
      SodiumIdentityRepository(
        sodium: sodium,
        database: database,
        privateStore: MemoryPrivateIdentityStore(),
      ).load(),
      throwsA(
        isA<IdentityStorageException>().having(
          (IdentityStorageException error) => error.code,
          'code',
          IdentityStorageFailureCode.missingPrivateIdentity,
        ),
      ),
    );
    await database.close();
  });

  test('public-key mismatch fails closed', () async {
    final database = AppDatabase(NativeDatabase.memory());
    final secureStore = MemoryPrivateIdentityStore();
    final repository = SodiumIdentityRepository(
      sodium: sodium,
      database: database,
      privateStore: secureStore,
    );
    final created = await repository.create(DisplayName.parse('Raiyan'));
    await database.saveLocalProfile(
      IdentityProfile(
        deviceId: created.deviceId,
        publicKey: PublicKeyBytes(List<int>.filled(32, 7)),
        displayName: created.displayName,
        revision: created.revision,
        createdAt: created.profile.createdAt,
        updatedAt: created.profile.updatedAt,
      ),
    );

    expect(
      repository.load(),
      throwsA(
        isA<IdentityStorageException>().having(
          (IdentityStorageException error) => error.code,
          'code',
          IdentityStorageFailureCode.identityMismatch,
        ),
      ),
    );
    await database.close();
  });

  test('secure secret and public key mismatch fails closed', () async {
    final database = AppDatabase(NativeDatabase.memory());
    final secureStore = MemoryPrivateIdentityStore();
    final repository = SodiumIdentityRepository(
      sodium: sodium,
      database: database,
      privateStore: secureStore,
    );
    await repository.create(DisplayName.parse('Raiyan'));
    final original = secureStore.value!;
    final otherPair = sodium.crypto.sign.keyPair();
    final otherSecret = otherPair.secretKey.extractBytes();
    secureStore.value = PrivateIdentityEnvelope(
      publicKey: original.publicKey,
      secretKey: otherSecret,
      displayName: original.displayName,
      profileRevision: original.profileRevision,
      createdAtMicros: original.createdAtMicros,
      updatedAtMicros: original.updatedAtMicros,
    );
    otherSecret.fillRange(0, otherSecret.length, 0);
    otherPair.dispose();

    expect(
      repository.load(),
      throwsA(
        isA<IdentityStorageException>().having(
          (IdentityStorageException error) => error.code,
          'code',
          IdentityStorageFailureCode.corruptPrivateIdentity,
        ),
      ),
    );
    await database.close();
  });

  test(
    'newer secure profile revision repairs an interrupted database write',
    () async {
      final database = AppDatabase(NativeDatabase.memory());
      final secureStore = MemoryPrivateIdentityStore();
      final repository = SodiumIdentityRepository(
        sodium: sodium,
        database: database,
        privateStore: secureStore,
      );
      final created = await repository.create(DisplayName.parse('Before'));
      final original = secureStore.value!;
      secureStore.value = PrivateIdentityEnvelope(
        publicKey: original.publicKey,
        secretKey: original.secretKey,
        displayName: 'After',
        profileRevision: 2,
        createdAtMicros: original.createdAtMicros,
        updatedAtMicros: original.updatedAtMicros + 1,
      );

      final recovered = await repository.load();

      expect(recovered!.deviceId, created.deviceId);
      expect(recovered.displayName.value, 'After');
      expect(recovered.revision, 2);
      expect((await database.readLocalProfile())!.revision, 2);
      await database.close();
    },
  );
}
