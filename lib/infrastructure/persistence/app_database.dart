import 'dart:async';

import 'package:drift/drift.dart';
import 'package:local_messenger/domain/bytes.dart';
import 'package:local_messenger/domain/contracts.dart';
import 'package:local_messenger/domain/identity.dart';
import 'package:local_messenger/domain/messaging.dart';

part 'app_database.g.dart';

@DataClassName('LocalProfileRow')
class LocalProfiles extends Table {
  IntColumn get singleton => integer().withDefault(const Constant<int>(1))();
  BlobColumn get deviceId => blob()();
  BlobColumn get publicKey => blob()();
  TextColumn get displayName => text()();
  IntColumn get revision => integer()();
  IntColumn get createdAtMicros => integer()();
  IntColumn get updatedAtMicros => integer()();

  @override
  Set<Column<Object>> get primaryKey => <Column<Object>>{singleton};

  @override
  List<String> get customConstraints => <String>['CHECK (singleton = 1)'];
}

@DataClassName('PinnedPeerRow')
class PinnedPeers extends Table {
  BlobColumn get deviceId => blob()();
  BlobColumn get publicKey => blob()();
  TextColumn get displayName => text()();
  IntColumn get profileRevision => integer()();
  IntColumn get profileCreatedAtMicros => integer()();
  IntColumn get profileUpdatedAtMicros => integer()();
  IntColumn get pinnedAtMicros => integer()();
  IntColumn get lastVerifiedAtMicros => integer()();
  TextColumn get trustState => text()();

  @override
  Set<Column<Object>> get primaryKey => <Column<Object>>{deviceId};
}

@DataClassName('ConversationRow')
class Conversations extends Table {
  BlobColumn get conversationId => blob()();
  BlobColumn get firstParticipantId => blob()();
  BlobColumn get secondParticipantId => blob()();
  IntColumn get createdAtMicros => integer()();

  @override
  Set<Column<Object>> get primaryKey => <Column<Object>>{conversationId};

  @override
  List<Set<Column<Object>>> get uniqueKeys => <Set<Column<Object>>>[
    <Column<Object>>{firstParticipantId, secondParticipantId},
  ];
}

@DataClassName('StoredOperationRow')
class StoredOperations extends Table {
  @override
  String get tableName => 'operations';

  BlobColumn get operationId => blob()();
  IntColumn get protocolVersion => integer()();
  BlobColumn get conversationId => blob()();
  BlobColumn get authorDeviceId => blob()();
  BlobColumn get recipientDeviceId => blob()();
  IntColumn get authorSequence => integer()();
  BlobColumn get previousOperationId => blob().nullable()();
  IntColumn get authoredAtMicros => integer()();
  TextColumn get messageText => text()();
  BlobColumn get signature => blob()();
  BlobColumn get canonicalBytes => blob()();
  IntColumn get receivedAtMicros => integer()();

  @override
  Set<Column<Object>> get primaryKey => <Column<Object>>{operationId};

  @override
  List<Set<Column<Object>>> get uniqueKeys => <Set<Column<Object>>>[
    <Column<Object>>{conversationId, authorDeviceId, authorSequence},
  ];

  @override
  List<String> get customConstraints => <String>[
    'FOREIGN KEY (conversation_id) REFERENCES conversations(conversation_id) ON DELETE CASCADE',
  ];
}

@DataClassName('FeedHeadRow')
class FeedHeads extends Table {
  BlobColumn get conversationId => blob()();
  BlobColumn get authorDeviceId => blob()();
  IntColumn get headSequence => integer()();
  BlobColumn get headOperationId => blob()();
  BoolColumn get isQuarantined =>
      boolean().withDefault(const Constant(false))();

  @override
  Set<Column<Object>> get primaryKey => <Column<Object>>{
    conversationId,
    authorDeviceId,
  };

  @override
  List<String> get customConstraints => <String>[
    'FOREIGN KEY (conversation_id) REFERENCES conversations(conversation_id) ON DELETE CASCADE',
  ];
}

@DataClassName('MessageProjectionRow')
class MessageProjections extends Table {
  BlobColumn get operationId => blob()();
  BlobColumn get conversationId => blob()();
  BlobColumn get authorDeviceId => blob()();
  BlobColumn get recipientDeviceId => blob()();
  IntColumn get authorSequence => integer()();
  IntColumn get authoredAtMicros => integer()();
  TextColumn get messageText => text()();
  IntColumn get insertedAtMicros => integer()();

  @override
  Set<Column<Object>> get primaryKey => <Column<Object>>{operationId};

  @override
  List<String> get customConstraints => <String>[
    'FOREIGN KEY (operation_id) REFERENCES operations(operation_id) ON DELETE CASCADE',
    'FOREIGN KEY (conversation_id) REFERENCES conversations(conversation_id) ON DELETE CASCADE',
  ];
}

@DataClassName('RetentionFloorRow')
class RetentionFloors extends Table {
  BlobColumn get conversationId => blob()();
  BlobColumn get authorDeviceId => blob()();
  IntColumn get retainedThroughSequence => integer()();

  @override
  Set<Column<Object>> get primaryKey => <Column<Object>>{
    conversationId,
    authorDeviceId,
  };

  @override
  List<String> get customConstraints => <String>[
    'FOREIGN KEY (conversation_id) REFERENCES conversations(conversation_id) ON DELETE CASCADE',
  ];
}

@DataClassName('DeliveryAcknowledgementRow')
class DeliveryAcknowledgements extends Table {
  BlobColumn get conversationId => blob()();
  BlobColumn get authorDeviceId => blob()();
  BlobColumn get recipientDeviceId => blob()();
  IntColumn get highestSequence => integer()();
  IntColumn get updatedAtMicros => integer()();

  @override
  Set<Column<Object>> get primaryKey => <Column<Object>>{
    conversationId,
    authorDeviceId,
    recipientDeviceId,
  };

  @override
  List<String> get customConstraints => <String>[
    'FOREIGN KEY (conversation_id) REFERENCES conversations(conversation_id) ON DELETE CASCADE',
  ];
}

@DriftDatabase(
  tables: <Type>[
    LocalProfiles,
    PinnedPeers,
    Conversations,
    StoredOperations,
    FeedHeads,
    MessageProjections,
    RetentionFloors,
    DeliveryAcknowledgements,
  ],
)
class AppDatabase extends _$AppDatabase implements OperationStore {
  AppDatabase(super.executor, {OperationValidator? operationValidator})
    : _operationValidator =
          operationValidator ?? const StructuralOperationValidator();

  final OperationValidator _operationValidator;

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (Migrator migrator) async {
      await migrator.createAll();
    },
    onUpgrade: (Migrator migrator, int from, int to) async {
      if (from != to) {
        throw StateError('No migration path exists from schema $from to $to.');
      }
    },
    beforeOpen: (OpeningDetails details) async {
      await customStatement('PRAGMA foreign_keys = ON');
      await customStatement(
        'CREATE INDEX IF NOT EXISTS operations_conversation_time_idx '
        'ON "operations" (conversation_id, authored_at_micros, author_device_id, author_sequence)',
      );
      await customStatement(
        'CREATE INDEX IF NOT EXISTS projections_conversation_time_idx '
        'ON message_projections (conversation_id, authored_at_micros, author_device_id, author_sequence)',
      );
    },
  );

  Future<IdentityProfile?> readLocalProfile() async {
    final row = await select(localProfiles).getSingleOrNull();
    return row == null ? null : _profileFromRow(row);
  }

  Stream<IdentityProfile?> watchLocalProfile() => select(localProfiles)
      .watchSingleOrNull()
      .map((LocalProfileRow? row) => row == null ? null : _profileFromRow(row));

  Future<void> saveLocalProfile(IdentityProfile profile) async {
    await into(localProfiles).insertOnConflictUpdate(
      LocalProfilesCompanion.insert(
        singleton: const Value<int>(1),
        deviceId: profile.deviceId.bytes,
        publicKey: profile.publicKey.bytes,
        displayName: profile.displayName.value,
        revision: profile.revision,
        createdAtMicros: profile.createdAt.toUtc().microsecondsSinceEpoch,
        updatedAtMicros: profile.updatedAt.toUtc().microsecondsSinceEpoch,
      ),
    );
  }

  Future<void> savePinnedPeer(PinnedPeer peer) async {
    await into(pinnedPeers).insertOnConflictUpdate(
      PinnedPeersCompanion.insert(
        deviceId: peer.profile.deviceId.bytes,
        publicKey: peer.profile.publicKey.bytes,
        displayName: peer.profile.displayName.value,
        profileRevision: peer.profile.revision,
        profileCreatedAtMicros: peer.profile.createdAt
            .toUtc()
            .microsecondsSinceEpoch,
        profileUpdatedAtMicros: peer.profile.updatedAt
            .toUtc()
            .microsecondsSinceEpoch,
        pinnedAtMicros: peer.pinnedAt.toUtc().microsecondsSinceEpoch,
        lastVerifiedAtMicros: peer.lastVerifiedAt
            .toUtc()
            .microsecondsSinceEpoch,
        trustState: peer.trustState.name,
      ),
    );
  }

  Future<void> saveConversation(DirectConversation conversation) async {
    final participants =
        <DeviceId>[
          conversation.firstParticipant,
          conversation.secondParticipant,
        ]..sort(
          (DeviceId left, DeviceId right) =>
              compareBytes(left.bytes, right.bytes),
        );
    await into(conversations).insert(
      ConversationsCompanion.insert(
        conversationId: conversation.id.bytes,
        firstParticipantId: participants.first.bytes,
        secondParticipantId: participants.last.bytes,
        createdAtMicros: conversation.createdAt.toUtc().microsecondsSinceEpoch,
      ),
      mode: InsertMode.insertOrIgnore,
    );
  }

  Future<DirectConversation?> readConversation(
    ConversationId conversationId,
  ) async {
    final row =
        await (select(conversations)..where(
              (Conversations table) =>
                  table.conversationId.equals(conversationId.bytes),
            ))
            .getSingleOrNull();
    return row == null ? null : _conversationFromRow(row);
  }

  @override
  Future<OperationInsertResult> insert(MessageOperation operation) async {
    final conversation = await readConversation(operation.conversationId);
    if (conversation == null) {
      throw const OperationValidationException(
        OperationValidationCode.invalidConversationId,
        'The operation references an unknown conversation.',
      );
    }
    _operationValidator.validateStatic(operation, conversation);

    return transaction(() async {
      final sameId =
          await (select(storedOperations)..where(
                (StoredOperations table) =>
                    table.operationId.equals(operation.id.bytes),
              ))
              .getSingleOrNull();
      if (sameId != null) {
        if (bytesEqual(sameId.canonicalBytes, operation.canonicalBytes) &&
            bytesEqual(sameId.signature, operation.signature)) {
          return OperationInsertResult.duplicate;
        }
        await _quarantine(operation.conversationId, operation.authorDeviceId);
        return OperationInsertResult.forkQuarantined;
      }

      final sameSequence =
          await (select(storedOperations)..where(
                (StoredOperations table) =>
                    table.conversationId.equals(
                      operation.conversationId.bytes,
                    ) &
                    table.authorDeviceId.equals(
                      operation.authorDeviceId.bytes,
                    ) &
                    table.authorSequence.equals(operation.authorSequence),
              ))
              .getSingleOrNull();
      if (sameSequence != null) {
        await _quarantine(operation.conversationId, operation.authorDeviceId);
        return OperationInsertResult.forkQuarantined;
      }

      final head = await _readFeedHead(
        operation.conversationId,
        operation.authorDeviceId,
      );
      if (head?.isQuarantined ?? false) {
        throw const OperationValidationException(
          OperationValidationCode.quarantinedFeed,
          'The author feed is quarantined.',
        );
      }
      _validateContinuity(operation, head);

      final receivedAt = DateTime.now().toUtc().microsecondsSinceEpoch;
      await into(storedOperations).insert(
        StoredOperationsCompanion.insert(
          operationId: operation.id.bytes,
          protocolVersion: operation.protocolVersion,
          conversationId: operation.conversationId.bytes,
          authorDeviceId: operation.authorDeviceId.bytes,
          recipientDeviceId: operation.recipientDeviceId.bytes,
          authorSequence: operation.authorSequence,
          previousOperationId: Value<Uint8List?>(
            operation.previousOperationId?.bytes,
          ),
          authoredAtMicros: operation.authoredAt.toUtc().microsecondsSinceEpoch,
          messageText: operation.text,
          signature: Uint8List.fromList(operation.signature),
          canonicalBytes: Uint8List.fromList(operation.canonicalBytes),
          receivedAtMicros: receivedAt,
        ),
      );
      await into(feedHeads).insertOnConflictUpdate(
        FeedHeadsCompanion.insert(
          conversationId: operation.conversationId.bytes,
          authorDeviceId: operation.authorDeviceId.bytes,
          headSequence: operation.authorSequence,
          headOperationId: operation.id.bytes,
        ),
      );

      final floor = await _readRetentionFloor(
        operation.conversationId,
        operation.authorDeviceId,
      );
      if (operation.authorSequence > floor) {
        await _insertProjection(operation, receivedAt);
      }
      return OperationInsertResult.inserted;
    });
  }

  @override
  Future<List<FeedHead>> readFrontier(ConversationId conversationId) async {
    final rows =
        await (select(feedHeads)..where(
              (FeedHeads table) =>
                  table.conversationId.equals(conversationId.bytes),
            ))
            .get();
    return rows
        .map(
          (FeedHeadRow row) => FeedHead(
            conversationId: ConversationId(row.conversationId),
            authorDeviceId: DeviceId(row.authorDeviceId),
            sequence: row.headSequence,
            operationId: OperationId(row.headOperationId),
            isQuarantined: row.isQuarantined,
          ),
        )
        .toList();
  }

  @override
  Future<List<MessageOperation>> readRange({
    required ConversationId conversationId,
    required DeviceId authorDeviceId,
    required int afterSequence,
    required int limit,
  }) async {
    if (limit < 1 || limit > 256) {
      throw ArgumentError.value(limit, 'limit', 'must be between 1 and 256');
    }
    final rows =
        await (select(storedOperations)
              ..where(
                (StoredOperations table) =>
                    table.conversationId.equals(conversationId.bytes) &
                    table.authorDeviceId.equals(authorDeviceId.bytes) &
                    table.authorSequence.isBiggerThanValue(afterSequence),
              )
              ..orderBy(<OrderClauseGenerator<$StoredOperationsTable>>[
                (StoredOperations table) =>
                    OrderingTerm.asc(table.authorSequence),
              ])
              ..limit(limit))
            .get();
    return rows.map(_operationFromRow).toList();
  }

  @override
  Future<void> rebuildMessageProjections() => transaction(() async {
    await delete(messageProjections).go();
    final operations = await select(storedOperations).get();
    final floors = await select(retentionFloors).get();
    final floorByFeed = <String, int>{
      for (final floor in floors)
        _feedKey(floor.conversationId, floor.authorDeviceId):
            floor.retainedThroughSequence,
    };
    operations.sort((StoredOperationRow left, StoredOperationRow right) {
      final time = left.authoredAtMicros.compareTo(right.authoredAtMicros);
      if (time != 0) return time;
      final author = compareBytes(left.authorDeviceId, right.authorDeviceId);
      if (author != 0) return author;
      return left.authorSequence.compareTo(right.authorSequence);
    });
    for (final operation in operations) {
      final floor =
          floorByFeed[_feedKey(
            operation.conversationId,
            operation.authorDeviceId,
          )] ??
          0;
      if (operation.authorSequence > floor) {
        await into(messageProjections).insert(
          MessageProjectionsCompanion.insert(
            operationId: operation.operationId,
            conversationId: operation.conversationId,
            authorDeviceId: operation.authorDeviceId,
            recipientDeviceId: operation.recipientDeviceId,
            authorSequence: operation.authorSequence,
            authoredAtMicros: operation.authoredAtMicros,
            messageText: operation.messageText,
            insertedAtMicros: operation.receivedAtMicros,
          ),
          mode: InsertMode.insertOrIgnore,
        );
      }
    }
  });

  @override
  Stream<List<VisibleMessage>> watchMessages(ConversationId conversationId) {
    const sql = '''
SELECT o.operation_id, o.protocol_version, o.conversation_id, o.author_device_id,
       o.recipient_device_id, o.author_sequence, o.previous_operation_id,
       o.authored_at_micros, o.message_text, o.signature, o.canonical_bytes,
       CASE WHEN a.highest_sequence >= o.author_sequence THEN 1 ELSE 0 END AS delivered
FROM message_projections AS p
JOIN "operations" AS o ON o.operation_id = p.operation_id
LEFT JOIN delivery_acknowledgements AS a
  ON a.conversation_id = o.conversation_id
 AND a.author_device_id = o.author_device_id
 AND a.recipient_device_id = o.recipient_device_id
WHERE p.conversation_id = ?1
ORDER BY o.authored_at_micros, o.author_device_id, o.author_sequence
''';
    return customSelect(
      sql,
      variables: <Variable<Object>>[Variable<Uint8List>(conversationId.bytes)],
      readsFrom: <ResultSetImplementation<Table, Object?>>{
        messageProjections,
        storedOperations,
        deliveryAcknowledgements,
      },
    ).watch().map(
      (List<QueryRow> rows) => rows.map(_visibleMessageFromQueryRow).toList(),
    );
  }

  @override
  Future<void> recordAcknowledgement(
    DeliveryAcknowledgement acknowledgement,
  ) async {
    if (acknowledgement.highestSequence < 0) {
      throw ArgumentError.value(
        acknowledgement.highestSequence,
        'highestSequence',
        'must not be negative',
      );
    }
    await transaction(() async {
      final existing =
          await (select(deliveryAcknowledgements)..where(
                (DeliveryAcknowledgements table) =>
                    table.conversationId.equals(
                      acknowledgement.conversationId.bytes,
                    ) &
                    table.authorDeviceId.equals(
                      acknowledgement.authorDeviceId.bytes,
                    ) &
                    table.recipientDeviceId.equals(
                      acknowledgement.recipientDeviceId.bytes,
                    ),
              ))
              .getSingleOrNull();
      if (existing != null &&
          existing.highestSequence >= acknowledgement.highestSequence) {
        return;
      }
      await into(deliveryAcknowledgements).insertOnConflictUpdate(
        DeliveryAcknowledgementsCompanion.insert(
          conversationId: acknowledgement.conversationId.bytes,
          authorDeviceId: acknowledgement.authorDeviceId.bytes,
          recipientDeviceId: acknowledgement.recipientDeviceId.bytes,
          highestSequence: acknowledgement.highestSequence,
          updatedAtMicros: acknowledgement.updatedAt
              .toUtc()
              .microsecondsSinceEpoch,
        ),
      );
    });
  }

  @override
  Future<void> setRetentionFloor(RetentionFloor floor) async {
    if (floor.retainedThroughSequence < 0) {
      throw ArgumentError.value(
        floor.retainedThroughSequence,
        'retainedThroughSequence',
        'must not be negative',
      );
    }
    await transaction(() async {
      final existing =
          await (select(retentionFloors)..where(
                (RetentionFloors table) =>
                    table.conversationId.equals(floor.conversationId.bytes) &
                    table.authorDeviceId.equals(floor.authorDeviceId.bytes),
              ))
              .getSingleOrNull();
      if (existing != null &&
          existing.retainedThroughSequence >= floor.retainedThroughSequence) {
        return;
      }
      await into(retentionFloors).insertOnConflictUpdate(
        RetentionFloorsCompanion.insert(
          conversationId: floor.conversationId.bytes,
          authorDeviceId: floor.authorDeviceId.bytes,
          retainedThroughSequence: floor.retainedThroughSequence,
        ),
      );
      await (delete(messageProjections)..where(
            (MessageProjections table) =>
                table.conversationId.equals(floor.conversationId.bytes) &
                table.authorDeviceId.equals(floor.authorDeviceId.bytes) &
                table.authorSequence.isSmallerOrEqualValue(
                  floor.retainedThroughSequence,
                ),
          ))
          .go();
    });
  }

  Future<FeedHeadRow?> _readFeedHead(
    ConversationId conversationId,
    DeviceId authorDeviceId,
  ) =>
      (select(feedHeads)..where(
            (FeedHeads table) =>
                table.conversationId.equals(conversationId.bytes) &
                table.authorDeviceId.equals(authorDeviceId.bytes),
          ))
          .getSingleOrNull();

  Future<int> _readRetentionFloor(
    ConversationId conversationId,
    DeviceId authorDeviceId,
  ) async {
    final row =
        await (select(retentionFloors)..where(
              (RetentionFloors table) =>
                  table.conversationId.equals(conversationId.bytes) &
                  table.authorDeviceId.equals(authorDeviceId.bytes),
            ))
            .getSingleOrNull();
    return row?.retainedThroughSequence ?? 0;
  }

  Future<void> _quarantine(
    ConversationId conversationId,
    DeviceId authorDeviceId,
  ) async {
    final head = await _readFeedHead(conversationId, authorDeviceId);
    if (head != null) {
      await (update(feedHeads)..where(
            (FeedHeads table) =>
                table.conversationId.equals(conversationId.bytes) &
                table.authorDeviceId.equals(authorDeviceId.bytes),
          ))
          .write(const FeedHeadsCompanion(isQuarantined: Value<bool>(true)));
    }
  }

  void _validateContinuity(MessageOperation operation, FeedHeadRow? head) {
    final expectedSequence = (head?.headSequence ?? 0) + 1;
    if (operation.authorSequence != expectedSequence) {
      throw OperationValidationException(
        OperationValidationCode.invalidSequence,
        'Expected author sequence $expectedSequence.',
      );
    }
    if (head == null && operation.previousOperationId != null) {
      throw const OperationValidationException(
        OperationValidationCode.invalidPreviousOperation,
        'The first operation cannot have a predecessor.',
      );
    }
    if (head != null &&
        operation.previousOperationId != OperationId(head.headOperationId)) {
      throw const OperationValidationException(
        OperationValidationCode.invalidPreviousOperation,
        'The operation predecessor does not match the feed head.',
      );
    }
  }

  Future<void> _insertProjection(
    MessageOperation operation,
    int insertedAtMicros,
  ) => into(messageProjections).insert(
    MessageProjectionsCompanion.insert(
      operationId: operation.id.bytes,
      conversationId: operation.conversationId.bytes,
      authorDeviceId: operation.authorDeviceId.bytes,
      recipientDeviceId: operation.recipientDeviceId.bytes,
      authorSequence: operation.authorSequence,
      authoredAtMicros: operation.authoredAt.toUtc().microsecondsSinceEpoch,
      messageText: operation.text,
      insertedAtMicros: insertedAtMicros,
    ),
  );

  IdentityProfile _profileFromRow(LocalProfileRow row) => IdentityProfile(
    deviceId: DeviceId(row.deviceId),
    publicKey: PublicKeyBytes(row.publicKey),
    displayName: DisplayName.parse(row.displayName),
    revision: row.revision,
    createdAt: DateTime.fromMicrosecondsSinceEpoch(
      row.createdAtMicros,
      isUtc: true,
    ),
    updatedAt: DateTime.fromMicrosecondsSinceEpoch(
      row.updatedAtMicros,
      isUtc: true,
    ),
  );

  DirectConversation _conversationFromRow(ConversationRow row) =>
      DirectConversation(
        id: ConversationId(row.conversationId),
        firstParticipant: DeviceId(row.firstParticipantId),
        secondParticipant: DeviceId(row.secondParticipantId),
        createdAt: DateTime.fromMicrosecondsSinceEpoch(
          row.createdAtMicros,
          isUtc: true,
        ),
      );

  VisibleMessage _visibleMessageFromQueryRow(QueryRow row) => VisibleMessage(
    operation: MessageOperation(
      id: OperationId(row.read<Uint8List>('operation_id')),
      protocolVersion: row.read<int>('protocol_version'),
      conversationId: ConversationId(row.read<Uint8List>('conversation_id')),
      authorDeviceId: DeviceId(row.read<Uint8List>('author_device_id')),
      recipientDeviceId: DeviceId(row.read<Uint8List>('recipient_device_id')),
      authorSequence: row.read<int>('author_sequence'),
      previousOperationId: _operationIdOrNull(
        row.readNullable<Uint8List>('previous_operation_id'),
      ),
      authoredAt: DateTime.fromMicrosecondsSinceEpoch(
        row.read<int>('authored_at_micros'),
        isUtc: true,
      ),
      text: row.read<String>('message_text'),
      signature: row.read<Uint8List>('signature'),
      canonicalBytes: row.read<Uint8List>('canonical_bytes'),
    ),
    deliveryState: row.read<int>('delivered') == 1
        ? DeliveryState.delivered
        : DeliveryState.queued,
  );

  MessageOperation _operationFromRow(StoredOperationRow row) =>
      MessageOperation(
        id: OperationId(row.operationId),
        protocolVersion: row.protocolVersion,
        conversationId: ConversationId(row.conversationId),
        authorDeviceId: DeviceId(row.authorDeviceId),
        recipientDeviceId: DeviceId(row.recipientDeviceId),
        authorSequence: row.authorSequence,
        previousOperationId: _operationIdOrNull(row.previousOperationId),
        authoredAt: DateTime.fromMicrosecondsSinceEpoch(
          row.authoredAtMicros,
          isUtc: true,
        ),
        text: row.messageText,
        signature: row.signature,
        canonicalBytes: row.canonicalBytes,
      );
}

String _feedKey(List<int> conversationId, List<int> authorDeviceId) =>
    '${encodeHex(conversationId)}:${encodeHex(authorDeviceId)}';

OperationId? _operationIdOrNull(Uint8List? bytes) =>
    bytes == null ? null : OperationId(bytes);
