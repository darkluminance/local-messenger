// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'drift_spike.dart';

// ignore_for_file: type=lint
class $Phase0RecordsTable extends Phase0Records
    with TableInfo<$Phase0RecordsTable, Phase0Record> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $Phase0RecordsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _recordKeyMeta = const VerificationMeta(
    'recordKey',
  );
  @override
  late final GeneratedColumn<String> recordKey = GeneratedColumn<String>(
    'record_key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _recordValueMeta = const VerificationMeta(
    'recordValue',
  );
  @override
  late final GeneratedColumn<int> recordValue = GeneratedColumn<int>(
    'record_value',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [recordKey, recordValue];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'phase0_records';
  @override
  VerificationContext validateIntegrity(
    Insertable<Phase0Record> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('record_key')) {
      context.handle(
        _recordKeyMeta,
        recordKey.isAcceptableOrUnknown(data['record_key']!, _recordKeyMeta),
      );
    } else if (isInserting) {
      context.missing(_recordKeyMeta);
    }
    if (data.containsKey('record_value')) {
      context.handle(
        _recordValueMeta,
        recordValue.isAcceptableOrUnknown(
          data['record_value']!,
          _recordValueMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_recordValueMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {recordKey};
  @override
  Phase0Record map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Phase0Record(
      recordKey: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}record_key'],
      )!,
      recordValue: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}record_value'],
      )!,
    );
  }

  @override
  $Phase0RecordsTable createAlias(String alias) {
    return $Phase0RecordsTable(attachedDatabase, alias);
  }
}

class Phase0Record extends DataClass implements Insertable<Phase0Record> {
  final String recordKey;
  final int recordValue;
  const Phase0Record({required this.recordKey, required this.recordValue});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['record_key'] = Variable<String>(recordKey);
    map['record_value'] = Variable<int>(recordValue);
    return map;
  }

  Phase0RecordsCompanion toCompanion(bool nullToAbsent) {
    return Phase0RecordsCompanion(
      recordKey: Value(recordKey),
      recordValue: Value(recordValue),
    );
  }

  factory Phase0Record.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Phase0Record(
      recordKey: serializer.fromJson<String>(json['recordKey']),
      recordValue: serializer.fromJson<int>(json['recordValue']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'recordKey': serializer.toJson<String>(recordKey),
      'recordValue': serializer.toJson<int>(recordValue),
    };
  }

  Phase0Record copyWith({String? recordKey, int? recordValue}) => Phase0Record(
    recordKey: recordKey ?? this.recordKey,
    recordValue: recordValue ?? this.recordValue,
  );
  Phase0Record copyWithCompanion(Phase0RecordsCompanion data) {
    return Phase0Record(
      recordKey: data.recordKey.present ? data.recordKey.value : this.recordKey,
      recordValue: data.recordValue.present
          ? data.recordValue.value
          : this.recordValue,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Phase0Record(')
          ..write('recordKey: $recordKey, ')
          ..write('recordValue: $recordValue')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(recordKey, recordValue);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Phase0Record &&
          other.recordKey == this.recordKey &&
          other.recordValue == this.recordValue);
}

class Phase0RecordsCompanion extends UpdateCompanion<Phase0Record> {
  final Value<String> recordKey;
  final Value<int> recordValue;
  final Value<int> rowid;
  const Phase0RecordsCompanion({
    this.recordKey = const Value.absent(),
    this.recordValue = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  Phase0RecordsCompanion.insert({
    required String recordKey,
    required int recordValue,
    this.rowid = const Value.absent(),
  }) : recordKey = Value(recordKey),
       recordValue = Value(recordValue);
  static Insertable<Phase0Record> custom({
    Expression<String>? recordKey,
    Expression<int>? recordValue,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (recordKey != null) 'record_key': recordKey,
      if (recordValue != null) 'record_value': recordValue,
      if (rowid != null) 'rowid': rowid,
    });
  }

  Phase0RecordsCompanion copyWith({
    Value<String>? recordKey,
    Value<int>? recordValue,
    Value<int>? rowid,
  }) {
    return Phase0RecordsCompanion(
      recordKey: recordKey ?? this.recordKey,
      recordValue: recordValue ?? this.recordValue,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (recordKey.present) {
      map['record_key'] = Variable<String>(recordKey.value);
    }
    if (recordValue.present) {
      map['record_value'] = Variable<int>(recordValue.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('Phase0RecordsCompanion(')
          ..write('recordKey: $recordKey, ')
          ..write('recordValue: $recordValue, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$Phase0Database extends GeneratedDatabase {
  _$Phase0Database(QueryExecutor e) : super(e);
  $Phase0DatabaseManager get managers => $Phase0DatabaseManager(this);
  late final $Phase0RecordsTable phase0Records = $Phase0RecordsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [phase0Records];
}

typedef $$Phase0RecordsTableCreateCompanionBuilder =
    Phase0RecordsCompanion Function({
      required String recordKey,
      required int recordValue,
      Value<int> rowid,
    });
typedef $$Phase0RecordsTableUpdateCompanionBuilder =
    Phase0RecordsCompanion Function({
      Value<String> recordKey,
      Value<int> recordValue,
      Value<int> rowid,
    });

class $$Phase0RecordsTableFilterComposer
    extends Composer<_$Phase0Database, $Phase0RecordsTable> {
  $$Phase0RecordsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get recordKey => $composableBuilder(
    column: $table.recordKey,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get recordValue => $composableBuilder(
    column: $table.recordValue,
    builder: (column) => ColumnFilters(column),
  );
}

class $$Phase0RecordsTableOrderingComposer
    extends Composer<_$Phase0Database, $Phase0RecordsTable> {
  $$Phase0RecordsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get recordKey => $composableBuilder(
    column: $table.recordKey,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get recordValue => $composableBuilder(
    column: $table.recordValue,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$Phase0RecordsTableAnnotationComposer
    extends Composer<_$Phase0Database, $Phase0RecordsTable> {
  $$Phase0RecordsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get recordKey =>
      $composableBuilder(column: $table.recordKey, builder: (column) => column);

  GeneratedColumn<int> get recordValue => $composableBuilder(
    column: $table.recordValue,
    builder: (column) => column,
  );
}

class $$Phase0RecordsTableTableManager
    extends
        RootTableManager<
          _$Phase0Database,
          $Phase0RecordsTable,
          Phase0Record,
          $$Phase0RecordsTableFilterComposer,
          $$Phase0RecordsTableOrderingComposer,
          $$Phase0RecordsTableAnnotationComposer,
          $$Phase0RecordsTableCreateCompanionBuilder,
          $$Phase0RecordsTableUpdateCompanionBuilder,
          (
            Phase0Record,
            BaseReferences<_$Phase0Database, $Phase0RecordsTable, Phase0Record>,
          ),
          Phase0Record,
          PrefetchHooks Function()
        > {
  $$Phase0RecordsTableTableManager(
    _$Phase0Database db,
    $Phase0RecordsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$Phase0RecordsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$Phase0RecordsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$Phase0RecordsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> recordKey = const Value.absent(),
                Value<int> recordValue = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => Phase0RecordsCompanion(
                recordKey: recordKey,
                recordValue: recordValue,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String recordKey,
                required int recordValue,
                Value<int> rowid = const Value.absent(),
              }) => Phase0RecordsCompanion.insert(
                recordKey: recordKey,
                recordValue: recordValue,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$Phase0RecordsTableProcessedTableManager =
    ProcessedTableManager<
      _$Phase0Database,
      $Phase0RecordsTable,
      Phase0Record,
      $$Phase0RecordsTableFilterComposer,
      $$Phase0RecordsTableOrderingComposer,
      $$Phase0RecordsTableAnnotationComposer,
      $$Phase0RecordsTableCreateCompanionBuilder,
      $$Phase0RecordsTableUpdateCompanionBuilder,
      (
        Phase0Record,
        BaseReferences<_$Phase0Database, $Phase0RecordsTable, Phase0Record>,
      ),
      Phase0Record,
      PrefetchHooks Function()
    >;

class $Phase0DatabaseManager {
  final _$Phase0Database _db;
  $Phase0DatabaseManager(this._db);
  $$Phase0RecordsTableTableManager get phase0Records =>
      $$Phase0RecordsTableTableManager(_db, _db.phase0Records);
}
