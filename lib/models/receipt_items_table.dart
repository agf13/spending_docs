import 'package:drift/drift.dart';
import 'package:spending_docs/models/receipts_table.dart';

class ReceiptItems extends Table {
  // Primary key
  IntColumn get id => integer().autoIncrement()();

  // Foreign key
  IntColumn get receiptId =>
      integer().references(Receipts, #id, onDelete: KeyAction.cascade)();

  // Fields
  RealColumn get price => real()();
  TextColumn get itemName => text().withLength(max: 150)();
}
