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
const itemPrice = 150.0;
const itemName = 'item';
final textWith150Chars =
    'aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa';
final textWith151Chars =
    'aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa';
const unexistingReceiptId = 1000;

/*
  Main function tests
*/
void main() {
  late AppDatabase db;
  late int insertedReceiptId;
  late ReceiptsCompanion validReceipt;

  setUp(() async {
    db = AppDatabase(NativeDatabase.memory());

    // CRUCIAL: Tell SQLite to enforce foreign key constraints
    validReceipt = ReceiptsCompanion(
      amount: Value(amount),
      date: Value(date),
      storeName: Value(storeName),
      card: Value(card),
    );
    insertedReceiptId = await db.into(db.receipts).insert(validReceipt);
  });

  tearDown(() async {
    await db.close();
  });

  group('ReceiptItemsTable test', () {
    test('Can add valid receipt item to existing receipt', () async {
      ReceiptItemsCompanion item = ReceiptItemsCompanion(
        receiptId: Value(insertedReceiptId),
        price: Value(itemPrice),
        itemName: Value(itemName),
      );

      final itemId = await insertItem(db, item);
      final itemFromDb = await getItem(db, itemId);

      expect(itemFromDb.receiptId, equals(insertedReceiptId));
      expect(itemFromDb.id, equals(itemId));
      expect(itemFromDb.price, equals(itemPrice));
      expect(itemFromDb.itemName, equals(itemName));
    });

    test('Raise error when trying to add with unexisting receipt id', () async {
      ReceiptItemsCompanion invalidItem = ReceiptItemsCompanion(
        receiptId: Value(unexistingReceiptId),
        price: Value(itemPrice),
        itemName: Value(itemName),
      );

      expect(() => insertItem(db, invalidItem), throwsA(isA<Exception>()));
    });

    test('Can add with maximum itemName length', () async {
      ReceiptItemsCompanion item = ReceiptItemsCompanion(
        receiptId: Value(insertedReceiptId),
        price: Value(itemPrice),
        itemName: Value(textWith150Chars),
      );

      final itemId = await insertItem(db, item);
      final itemFromDb = await getItem(db, itemId);

      expect(itemFromDb.receiptId, equals(insertedReceiptId));
      expect(itemFromDb.price, equals(itemPrice));
      expect(itemFromDb.itemName, equals(textWith150Chars));
      expect(itemFromDb.id, equals(itemId));
    });

    test('Raise error when itemName too long', () async {
      ReceiptItemsCompanion item = ReceiptItemsCompanion(
        receiptId: Value(insertedReceiptId),
        price: Value(itemPrice),
        itemName: Value(textWith151Chars),
      );

      expect(() async {
        await insertItem(db, item);
      }, throwsA(isA<Exception>()));
    });
  });
}

Future<int> insertItem(AppDatabase db, ReceiptItemsCompanion item) async {
  final itemId = await db.into(db.receiptItems).insert(item);
  return itemId;
}

Future<ReceiptItem> getItem(AppDatabase db, int itemId) async {
  final itemFromDb = await (db.select(
    db.receiptItems,
  )..where((elem) => elem.id.equals(itemId))).getSingle();

  return itemFromDb;
}
