import 'package:drift/drift.dart';
import 'package:spending_docs/core/database/app_database.dart';
import 'package:spending_docs/features/receipt_image/data/tables/receipt_images_table.dart';
import 'package:spending_docs/features/receipts/data/tables/receipts_table.dart';

part 'receipt_images_dao.g.dart';

@DriftAccessor(tables: [Receipts, ReceiptImages])
class ReceiptImagesDao extends DatabaseAccessor<AppDatabase>
    with _$ReceiptImagesDaoMixin {
  ReceiptImagesDao(super.attachedDatabase);

  Future<int> insertReceiptImage(ReceiptImagesCompanion element) {
    return into(receiptImages).insert(element);
  }

  Future<ReceiptImage?> getById(int id) {
    final query = select(receiptImages);
    query.where((elem) => elem.id.equals(id));

    return query.getSingleOrNull();
  }

  Future<List<ReceiptImage>> getAll() {
    return select(receiptImages).get();
  }

  Future<List<ReceiptImage>> getAllByReceipt(int receiptId) {
    final query = select(receiptImages);
    query.where((elem) => elem.receiptId.equals(receiptId));

    return query.get();
  }

  Future<bool> updateReceiptImage(ReceiptImage element) {
    return update(receiptImages).replace(element);
  }

  Future<int> deleteReceiptImage(int id) {
    final query = delete(receiptImages);
    query.where((elem) => elem.id.equals(id));

    return query.go();
  }
}
