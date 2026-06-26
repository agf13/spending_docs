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

  Future<Receipt?> getById(int id) {
    final receiptsSelect = _db.select(_db.receipts);
    receiptsSelect.where((elem) => elem.id.equals(id));

    return receiptsSelect.getSingleOrNull();
  }

  Future<int> remove(int id) {
    return _db.deleteReceipt(id);
  }

  Future<int> getTotalItemsCount() async {
    final result = await _db
        .customSelect('SELECT COUNT(ID) AS countColumn FROM receipts')
        .getSingle();
    return result.read<int>('countColumn');
  }
}
