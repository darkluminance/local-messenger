import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';

part 'drift_spike.g.dart';

class Phase0Records extends Table {
  TextColumn get recordKey => text()();
  IntColumn get recordValue => integer()();

  @override
  Set<Column<Object>> get primaryKey => <Column<Object>>{recordKey};
}

@DriftDatabase(tables: <Type>[Phase0Records])
class Phase0Database extends _$Phase0Database {
  Phase0Database(super.executor);

  factory Phase0Database.at(File file) => Phase0Database(NativeDatabase(file));

  @override
  int get schemaVersion => 1;
}

Future<bool> runDriftPersistenceSpike(File file) async {
  final writer = Phase0Database.at(file);
  await writer
      .into(writer.phase0Records)
      .insert(
        Phase0RecordsCompanion.insert(recordKey: 'phase-0', recordValue: 1),
      );
  await writer.close();

  final reader = Phase0Database.at(file);
  final record = await (reader.select(
    reader.phase0Records,
  )..where((Phase0Records row) => row.recordKey.equals('phase-0'))).getSingle();
  await reader.close();
  return record.recordValue == 1;
}
