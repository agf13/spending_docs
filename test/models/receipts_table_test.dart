import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:spending_docs/database/app_database.dart';

/*
  Constant variables used for testing
*/
const amount = 12.0;
const storeName = 'store';
const card = '1234';
final dateNow = DateTime.now();
final date = DateTime(
  dateNow.year,
  dateNow.month,
  dateNow.day,
  dateNow.hour,
  dateNow.minute,
  dateNow.second,
);
final textWith150Chars =
    'aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa';
final textWith151Chars =
    'aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa';
final textWith4Chars = 'aaaa';
final textWith5Chars = 'aaaaa';

/*
  Main testing function
*/
void main() {
  late AppDatabase db;

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
  });

  tearDown(() async {
    await db.close();
  });

  group('ReceiptsTable testing', () {
    test('Add is successful', () async {
      ReceiptsCompanion receipt = ReceiptsCompanion(
        amount: Value(amount),
        date: Value(date),
        storeName: Value(storeName),
        card: Value(card),
      );

      final id = await insertReceipt(db, receipt);
      final receiptFromDb = await getReceipt(db, id);

      expect(receiptFromDb.id, equals(id));
      expect(receiptFromDb.amount, equals(amount));
      expect(receiptFromDb.date, equals(date));
      expect(receiptFromDb.storeName, equals(storeName));
      expect(receiptFromDb.card, equals(card));
    });

    test('Null amount throws error', () {
      ReceiptsCompanion invalidReceipt = ReceiptsCompanion(
        date: Value(date),
        storeName: Value(storeName),
        card: Value(card),
      );
      expect(() async {
        await insertReceipt(db, invalidReceipt);
      }, throwsA(isA<Exception>()));
    });

    /* // I was not able to test this. DateTimeColumn somehow allows missing values
    test('Null date throws error', () {
      expect(
        () => db.customInsert(
          'INSERT INTO receipts (amount, store_name, card) VALUES (?, ?, ?)',
          variables: [
            Variable.withReal(amount),
            Variable.withString(storeName),
            Variable.withString(card),
          ],
        ),
        throwsA(isA<Exception>),
      );
    });
    */

    test('Null storeName is ok', () async {
      ReceiptsCompanion receipt = ReceiptsCompanion(
        amount: Value(amount),
        date: Value(date),
        card: Value(card),
      );

      final id = await insertReceipt(db, receipt);
      final receiptFromDb = await getReceipt(db, id);

      expect(receiptFromDb.storeName, equals(null));
    });

    test('storeName with 150 chars is ok', () async {
      ReceiptsCompanion receipt = ReceiptsCompanion(
        amount: Value(amount),
        date: Value(date),
        storeName: Value(textWith150Chars),
        card: Value(card),
      );

      final id = await insertReceipt(db, receipt);
      final receiptFromDb = await getReceipt(db, id);

      expect(receiptFromDb.storeName, equals(textWith150Chars));
    });

    test('Too long storeName throws error', () {
      ReceiptsCompanion invalidReceipt = ReceiptsCompanion(
        amount: Value(amount),
        date: Value(date),
        storeName: Value(textWith151Chars),
        card: Value(card),
      );

      expect(() async {
        await insertReceipt(db, invalidReceipt);
      }, throwsA(isA<Exception>()));
    });

    test('Null card is ok', () async {
      ReceiptsCompanion receipt = ReceiptsCompanion(
        amount: Value(amount),
        date: Value(date),
        storeName: Value(storeName),
      );

      final id = await insertReceipt(db, receipt);
      final receiptFromDb = await getReceipt(db, id);

      expect(receiptFromDb.card, equals(null));
    });

    test('card with 4 chars is ok', () async {
      ReceiptsCompanion receipt = ReceiptsCompanion(
        amount: Value(amount),
        date: Value(date),
        storeName: Value(storeName),
        card: Value(textWith4Chars),
      );

      final id = await insertReceipt(db, receipt);
      final receiptFromDb = await getReceipt(db, id);

      expect(receiptFromDb.card, equals(textWith4Chars));
    });

    test('card with too many chars throws error', () {
      ReceiptsCompanion invalidReceipt = ReceiptsCompanion(
        amount: Value(amount),
        date: Value(date),
        storeName: Value(storeName),
        card: Value(textWith5Chars),
      );

      expect(() async {
        await insertReceipt(db, invalidReceipt);
      }, throwsA(isA<Exception>()));
    });
  });
}

Future<int> insertReceipt(AppDatabase db, ReceiptsCompanion receipt) async {
  return await db.into(db.receipts).insert(receipt);
}

Future<Receipt> getReceipt(AppDatabase db, int receiptId) async {
  return await (db.select(
    db.receipts,
  )..where((elem) => elem.id.equals(receiptId))).getSingle();
}
