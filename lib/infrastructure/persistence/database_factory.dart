import 'dart:io';

import 'package:drift/native.dart';
import 'package:local_messenger/infrastructure/persistence/app_database.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

const String localMessengerDatabaseFileName = 'local_messenger.sqlite';

Future<AppDatabase> openAppDatabase() async {
  final supportDirectory = await getApplicationSupportDirectory();
  await supportDirectory.create(recursive: true);
  return AppDatabase(
    NativeDatabase.createInBackground(
      File(path.join(supportDirectory.path, localMessengerDatabaseFileName)),
      setup: (database) {
        database.execute('PRAGMA journal_mode = WAL');
      },
    ),
  );
}

AppDatabase openAppDatabaseAt(File file) => AppDatabase(NativeDatabase(file));
