import 'package:drift/drift.dart';
import 'package:spending_docs/core/database/migrations/schema_migration_interface.dart';

class MigrationV2 extends SchemaMigrationInterface {
  @override
  int get fromVersion => 1;

  @override
  int get toVersion => 2;

  @override
  Future<void> run(Migrator m, GeneratedDatabase db) async {
    final receiptImageTable = db.allTables.singleWhere(
      (t) => t.actualTableName == 'receipt_images',
    );

    await m.createTable(receiptImageTable);
  }
}
