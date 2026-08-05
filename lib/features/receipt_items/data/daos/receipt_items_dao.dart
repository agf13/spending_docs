import 'package:drift/drift.dart';
import 'package:spending_docs/core/database/app_database.dart';
import 'package:spending_docs/features/receipt_items/data/tables/receipt_items_table.dart';
import 'package:spending_docs/features/receipts/data/tables/receipts_table.dart';

part 'receipt_items_dao.g.dart';

@DriftAccessor(tables: [Receipts, ReceiptItems])
class ReceiptItemsDao extends DatabaseAccessor<AppDatabase>
    with _$ReceiptItemsDaoMixin {
  ReceiptItemsDao(super.attachedDatabase);

  Future<int> insertReceiptItem(ReceiptItemsCompanion element) {
    return into(receiptItems).insert(element);
  }

  Future<ReceiptItem?> getById(int id) {
    final query = select(receiptItems);
    query.where((elem) => elem.id.equals(id));

    return query.getSingleOrNull();
  }

  Future<List<ReceiptItem>> getAllReceiptItems() {
    return select(receiptItems).get();
  }

  Future<List<ReceiptItem>> getAllByReceipt(int parentReceiptIt) {
    final query = select(receiptItems);
    query.where((elem) => elem.receiptId.equals(parentReceiptIt));

    return query.get();
  }

  Future<bool> updateReceiptItem(ReceiptItem element) {
    return update(receiptItems).replace(element);
  }

  Future<int> deleteReceiptItem(int id) async {
    final query = delete(receiptItems);
    query.where((elem) => elem.id.equals(id));

    return query.go();
  }

  Future<int> getTotalItemsCount() async {
    final result = await customSelect(
      'SELECT COUNT(ID) AS countColumn FROM receipt_items;',
    ).getSingle();

    return result.read<int>('countColumn');
  }
}
