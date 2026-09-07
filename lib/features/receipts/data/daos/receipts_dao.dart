import 'package:drift/drift.dart';
import 'package:spending_docs/core/database/app_database.dart';
import 'package:spending_docs/features/receipts/data/tables/receipts_table.dart';

part 'receipts_dao.g.dart';

@DriftAccessor(tables: [Receipts])
class ReceiptsDao extends DatabaseAccessor<AppDatabase>
    with _$ReceiptsDaoMixin {
  ReceiptsDao(super.attachedDatabase);

  Future<int> insertReceipt(ReceiptsCompanion receipt) {
    return into(receipts).insert(receipt);
  }

  Future<Receipt?> getById(int id) {
    final receiptsSelect = select(receipts);
    receiptsSelect.where((elem) => elem.id.equals(id));

    return receiptsSelect.getSingleOrNull();
  }

  Future<List<Receipt>> getAllReceipts() {
    return select(receipts).get();
  }

  Future<List<Receipt>> getLimited(int offset, int count) {
    final receiptsSelect = select(receipts);
    receiptsSelect.limit(count, offset: offset);

    return receiptsSelect.get();
  }

  Future<bool> updateReceipt(Receipt receipt) {
    return update(receipts).replace(receipt);
  }

  Future<int> deleteReceipt(int id) {
    return (delete(receipts)..where((tbl) => tbl.id.equals(id))).go();
  }

  Future<int> getTotalItemsCount() async {
    final result = await customSelect(
      'SELECT COUNT(ID) AS countColumn FROM receipts',
    ).getSingle();

    return result.read<int>('countColumn');
  }
}
