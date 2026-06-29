import 'package:spending_docs/database/app_database.dart';

class ReceiptItemsRepository {
  final AppDatabase _db;

  ReceiptItemsRepository(this._db);

  Future<int> add(ReceiptItemsCompanion receiptItem) {
    return _db.receiptItemsDao.insertReceiptItem(receiptItem);
  }

  Future<bool> update(ReceiptItem receiptItem) {
    return _db.receiptItemsDao.updateReceiptItem(receiptItem);
  }

  Future<List<ReceiptItem>> getAll() {
    return _db.receiptItemsDao.getAllReceiptItems();
  }

  Future<List<ReceiptItem>> getByReceiptId(int receiptId) {
    return _db.receiptItemsDao.getAllByReceipt(receiptId);
  }

  Future<ReceiptItem?> getById(int id) {
    return _db.receiptItemsDao.getById(id);
  }

  Future<int> remove(int id) {
    return _db.receiptItemsDao.deleteReceiptItem(id);
  }

  Future<int> getTotalItemsCount() async {
    return _db.receiptItemsDao.getTotalItemsCount();
  }
}
