import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:spending_docs/database/receipts_dao.dart';
import 'package:spending_docs/models/receipts_table.dart';
import 'package:spending_docs/models/receipt_items_table.dart';

part 'app_database.g.dart';

@DriftDatabase(tables: [Receipts, ReceiptItems], daos: [ReceiptsDao])
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? e])
    : super(e ?? driftDatabase(name: 'receipts_docs_db.sqlite'));

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      beforeOpen: (details) async {
        await customStatement('PRAGMA foreign_keys = ON;');
      },
    );
  }
}

/*
// If we plan to switch to lazy loading at some point
LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationSupportDirectory();
    final file = File(p.join(dbFolder.path, 'receipts_docs_db.sqlite'));

    return NativeDatabase(file);
  });
}
*/
