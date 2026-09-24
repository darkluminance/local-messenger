import 'dart:io';
import 'dart:typed_data';

import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:local_messenger/domain/identity.dart';
import 'package:local_messenger/domain/messaging.dart';
import 'package:local_messenger/infrastructure/persistence/app_database.dart';
import 'package:local_messenger/infrastructure/persistence/database_factory.dart';

void main() {
  group('AppDatabase schema v1', () {
    test('creates all eight tables and persists across reopen', () async {
      final directory = await Directory.systemTemp.createTemp(
        'local-messenger-drift-',
      );
      addTearDown(() => directory.delete(recursive: true));
      final file = File('${directory.path}${Platform.pathSeparator}app.sqlite');
      final profile = _profile(_device(1), 'Raiyan');

      final writer = openAppDatabaseAt(file);
      await writer.saveLocalProfile(profile);
      final tables = await writer
          .customSelect(
            "SELECT name FROM sqlite_master WHERE type = 'table' AND name NOT LIKE 'sqlite_%' ORDER BY name",
          )
          .get();
      expect(
        tables.map((row) => row.read<String>('name')),
        containsAll(<String>[
          'conversations',
          'delivery_acknowledgements',
          'feed_heads',
          'local_profiles',
          'message_projections',
          'operations',
          'pinned_peers',
          'retention_floors',
        ]),
      );
      await writer.close();

      final reader = openAppDatabaseAt(file);
      expect((await reader.readLocalProfile())?.displayName.value, 'Raiyan');
      await reader.close();
    });
  });

  group('operation insertion', () {
    late AppDatabase database;
    late DeviceId local;
    late DeviceId peer;
    late DirectConversation conversation;

    setUp(() async {
      database = AppDatabase(NativeDatabase.memory());
      local = _device(1);
      peer = _device(2);
      conversation = DirectConversation(
        id: ConversationId.forParticipants(local, peer),
        firstParticipant: local,
        secondParticipant: peer,
        createdAt: DateTime.utc(2026),
      );
      await database.saveConversation(conversation);
    });

    tearDown(() => database.close());

    test(
      'atomically inserts, advances the head, and detects duplicates',
      () async {
        final operation = _operation(
          conversation: conversation,
          author: local,
          recipient: peer,
          sequence: 1,
          text: 'hello',
        );

        expect(
          await database.insert(operation),
          OperationInsertResult.inserted,
        );
        expect(
          await database.insert(operation),
          OperationInsertResult.duplicate,
        );
        expect(
          await database.select(database.storedOperations).get(),
          hasLength(1),
        );
        expect(await database.select(database.feedHeads).get(), hasLength(1));
        expect(
          await database.select(database.messageProjections).get(),
          hasLength(1),
        );
      },
    );

    test('rejects discontinuous feeds without partial writes', () async {
      final gap = _operation(
        conversation: conversation,
        author: local,
        recipient: peer,
        sequence: 2,
        text: 'gap',
      );

      await expectLater(
        database.insert(gap),
        throwsA(
          isA<OperationValidationException>().having(
            (error) => error.code,
            'code',
            OperationValidationCode.invalidSequence,
          ),
        ),
      );
      expect(await database.select(database.storedOperations).get(), isEmpty);
      expect(await database.select(database.feedHeads).get(), isEmpty);
      expect(await database.select(database.messageProjections).get(), isEmpty);
    });

    test('quarantines a fork at an occupied author sequence', () async {
      final first = _operation(
        conversation: conversation,
        author: local,
        recipient: peer,
        sequence: 1,
        text: 'first',
      );
      final fork = _operation(
        conversation: conversation,
        author: local,
        recipient: peer,
        sequence: 1,
        text: 'fork',
      );
      await database.insert(first);

      expect(
        await database.insert(fork),
        OperationInsertResult.forkQuarantined,
      );
      expect(
        (await database.select(database.feedHeads).getSingle()).isQuarantined,
        isTrue,
      );
      expect(
        await database.select(database.storedOperations).get(),
        hasLength(1),
      );
    });

    test('retention floors survive projection rebuilds', () async {
      final operation = _operation(
        conversation: conversation,
        author: local,
        recipient: peer,
        sequence: 1,
        text: 'cleared locally',
      );
      await database.insert(operation);
      await database.setRetentionFloor(
        RetentionFloor(
          conversationId: conversation.id,
          authorDeviceId: local,
          retainedThroughSequence: 1,
        ),
      );

      expect(await database.select(database.messageProjections).get(), isEmpty);
      expect(
        await database.select(database.storedOperations).get(),
        hasLength(1),
      );
      await database.rebuildMessageProjections();
      expect(await database.select(database.messageProjections).get(), isEmpty);
    });

    test('acknowledgements update projected delivery state', () async {
      final operation = _operation(
        conversation: conversation,
        author: local,
        recipient: peer,
        sequence: 1,
        text: 'delivery',
      );
      await database.insert(operation);
      expect(
        (await database.watchMessages(conversation.id).first)
            .single
            .deliveryState,
        DeliveryState.queued,
      );

      await database.recordAcknowledgement(
        DeliveryAcknowledgement(
          conversationId: conversation.id,
          authorDeviceId: local,
          recipientDeviceId: peer,
          highestSequence: 1,
          updatedAt: DateTime.utc(2026),
        ),
      );
      expect(
        (await database.watchMessages(conversation.id).first)
            .single
            .deliveryState,
        DeliveryState.delivered,
      );
    });
  });
}

IdentityProfile _profile(DeviceId deviceId, String name) => IdentityProfile(
  deviceId: deviceId,
  publicKey: PublicKeyBytes(List<int>.filled(32, deviceId.bytes.first + 10)),
  displayName: DisplayName.parse(name),
  revision: 1,
  createdAt: DateTime.utc(2026),
  updatedAt: DateTime.utc(2026),
);

DeviceId _device(int byte) => DeviceId(List<int>.filled(32, byte));

MessageOperation _operation({
  required DirectConversation conversation,
  required DeviceId author,
  required DeviceId recipient,
  required int sequence,
  required String text,
  OperationId? previous,
}) {
  final canonical = Uint8List.fromList(<int>[
    sequence,
    ...text.codeUnits,
    ...author.bytes,
  ]);
  return MessageOperation(
    id: OperationId.fromCanonicalBytes(canonical),
    protocolVersion: 1,
    conversationId: conversation.id,
    authorDeviceId: author,
    recipientDeviceId: recipient,
    authorSequence: sequence,
    previousOperationId: previous,
    authoredAt: DateTime.utc(2026, 1, 1, 0, 0, sequence),
    text: text,
    signature: Uint8List.fromList(<int>[sequence, 42]),
    canonicalBytes: canonical,
  );
}
