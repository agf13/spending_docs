import 'package:drift/drift.dart';
import 'package:spending_docs/l10n/app_localizations.dart';

class Receipts extends Table {
  IntColumn get id => integer().autoIncrement()();

  RealColumn get amount => real()();
  DateTimeColumn get date => dateTime()();
  TextColumn get storeName => text().withLength(max: 150).nullable()();
  TextColumn get card => text().withLength(max: 4).nullable()();
}
