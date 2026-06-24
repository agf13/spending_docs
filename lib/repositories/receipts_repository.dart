import 'package:spending_docs/database/app_database.dart';

class ReceiptsRepository {
  final AppDatabase _db;

  ReceiptsRepository(this._db);

  Future<int> add(ReceiptsCompanion receipt) {
    return _db.insertReceipt(receipt);
  }

  Future<bool> update(Receipt receipt) {
    return _db.updateReceipt(receipt);
  }

  Future<List<Receipt>> getAll() {
    return _db.getAllReceipts();
  }

  Future<int> remove(int id) {
    return _db.deleteReceipt(id);
  }
}
