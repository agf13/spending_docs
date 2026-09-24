import 'package:drift/drift.dart';
import 'package:spending_docs/core/database/migrations/schema_migration_interface.dart';
import 'package:spending_docs/core/database/migrations/steps/migration_v2.dart';

class SchemaMigrationHandler {
  Future<void> upgrade(
    Migrator m,
    GeneratedDatabase db,
    int from,
    int to,
  ) async {
    final stepsToRun = _migrations.where((migration) {
      return migration.fromVersion == from;
    });

    for (final step in stepsToRun) {
      await step.run(m, db);
    }
  }

  final List<SchemaMigrationInterface> _migrations = [MigrationV2()];
}
