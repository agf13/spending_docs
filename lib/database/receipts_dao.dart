import 'package:drift/drift.dart';
import 'package:spending_docs/database/app_database.dart';
import 'package:spending_docs/models/receipts_table.dart';

part 'receipts_dao.g.dart';

@DriftAccessor(tables: [Receipts])
class ReceiptsDao extends DatabaseAccessor<AppDatabase>
    with _$ReceiptsDaoMixin {
  ReceiptsDao(super.attachedDatabase);

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
