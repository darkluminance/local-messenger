import 'package:drift_dev/api/migrations_native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:local_messenger/infrastructure/persistence/app_database.dart';

import '../../generated_migrations/schema.dart';

void main() {
  test('frozen schema v1 matches the production database', () async {
    final verifier = SchemaVerifier(GeneratedHelper());
    final schema = await verifier.schemaAt(1);
    final database = AppDatabase(schema.newConnection());

    await verifier.migrateAndValidate(database, 1);

    await database.close();
    schema.close();
  });
}
