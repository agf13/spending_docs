import 'package:drift/drift.dart';
import 'package:spending_docs/models/receipts_table.dart';

class ReceiptItemsModel extends Table {
  // Primary key
  IntColumn get id => integer().autoIncrement()();

  // Foreign key
  IntColumn get receiptId =>
      integer().references(Receipts, #id, onDelete: KeyAction.cascade)();

  // Fields
  RealColumn get amount => real()();
  TextColumn get itenName => text().withLength(max: 150)();
}
