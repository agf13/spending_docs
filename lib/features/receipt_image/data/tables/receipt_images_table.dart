import 'package:drift/drift.dart';
import 'package:spending_docs/features/receipts/data/tables/receipts_table.dart';

class ReceiptImages extends Table {
  IntColumn get id => integer().autoIncrement()();

  IntColumn get receiptId =>
      integer().references(Receipts, #id, onDelete: KeyAction.cascade)();
  BlobColumn get imageData => blob()();
  IntColumn get imageNumber => integer()();
}
