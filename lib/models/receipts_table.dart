import 'package:drift/drift.dart';

class Receipts extends Table {
  IntColumn get id => integer().autoIncrement()();

  RealColumn get amount => real()();
  TextColumn get storeName => text().withLength(max: 150).nullable()();
  DateTimeColumn get date => dateTime().withDefault(currentDateAndTime)();
  TextColumn get card => text().withLength(max: 16).nullable()();
}
