import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:spending_docs/models/receipts_table.dart';
import 'package:spending_docs/models/receipt_items_table.dart';

part 'app_database.g.dart';

@DriftDatabase(tables: [Receipts, ReceiptItems])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(driftDatabase(name: 'receipts_docs_db.sqlite'));

  @override
  int get schemaVersion => 1;

  Future<int> insertReceipt(ReceiptsCompanion receipt) {
    return into(receipts).insert(receipt);
  }

  Future<List<Receipt>> getAllReceipts() {
    return select(receipts).get();
  }

  Future<bool> updateReceipt(Receipt receipt) {
    return update(receipts).replace(receipt);
  }

  Future<int> deleteReceipt(int id) {
    return (delete(receipts)..where((tbl) => tbl.id.equals(id))).go();
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
