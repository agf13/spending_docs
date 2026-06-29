import 'package:spending_docs/database/app_database.dart';

class ReceiptsRepository {
  final AppDatabase _db;

  ReceiptsRepository(this._db);

  Future<int> add(ReceiptsCompanion receipt) {
    return _db.receiptsDao.insertReceipt(receipt);
  }

  Future<bool> update(Receipt receipt) {
    return _db.receiptsDao.updateReceipt(receipt);
  }

  Future<List<Receipt>> getAll() {
    return _db.receiptsDao.getAllReceipts();
  }

  Future<Receipt?> getById(int id) {
    return _db.receiptsDao.getById(id);
  }

  Future<int> remove(int id) {
    return _db.receiptsDao.deleteReceipt(id);
  }

  Future<int> getTotalItemsCount() async {
    return _db.receiptsDao.getTotalItemsCount();
  }
}
