import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:spending_docs/database/app_database.dart';
import 'package:spending_docs/repositories/receipt_items_repository.dart';
import 'package:spending_docs/repositories/receipts_repository.dart';

const amount = 100.0;
final nowDate = DateTime.now();
final date = DateTime(
  nowDate.year,
  nowDate.month,
  nowDate.day,
  nowDate.hour,
  nowDate.minute,
  nowDate.second,
);
const storeName = 'store';
const card = '1234';

const price = 123.0;
const itemName = 'item';

const updatedPrice = 321.0;
const updatedItemName = 'updatedItem';

const invalidId = -1;

final receiptCompanion1 = ReceiptsCompanion(
  amount: Value(amount),
  date: Value(date),
  storeName: Value(storeName),
  card: Value(card),
);
final receiptCompanion2 = ReceiptsCompanion(
  amount: Value(amount),
  date: Value(date),
  storeName: Value(storeName),
  card: Value(card),
);

void main() {
  late AppDatabase db;
  late ReceiptItemsRepository repository;
  late int receiptId1, receiptId2, receiptItemId1, receiptItemId2;
  late ReceiptItemsCompanion receiptItemsCompanion1, receiptItemsCompanion2;

  setUp(() async {
    db = AppDatabase(NativeDatabase.memory());

    receiptId1 = await db.receiptsDao.insertReceipt(receiptCompanion1);
    receiptId2 = await db.receiptsDao.insertReceipt(receiptCompanion2);

    receiptItemsCompanion1 = ReceiptItemsCompanion(
      receiptId: Value(receiptId1),
      price: Value(price),
      itemName: Value(itemName),
    );
    receiptItemsCompanion2 = ReceiptItemsCompanion(
      receiptId: Value(receiptId2),
      price: Value(price),
      itemName: Value(itemName),
    );

    receiptItemId1 = await db.receiptItemsDao.insertReceiptItem(
      receiptItemsCompanion1,
    );
    receiptItemId2 = await db.receiptItemsDao.insertReceiptItem(
      receiptItemsCompanion2,
    );

    repository = ReceiptItemsRepository(db);
  });

  tearDown(() async {
    await db.close();
  });

  group('ReceiptItemsRepository', () {
    group('add', () {
      test('adds successfully', () async {
        final id = await repository.add(receiptItemsCompanion1);
        final itemFromDb = await repository.getById(id);

        expect(itemFromDb, isNot(null));
        expect(itemFromDb!.price, equals(price));
        expect(itemFromDb.itemName, equals(itemName));
      });

      test('on success returns the id of the new row', () async {
        final id = await repository.add(receiptItemsCompanion1);
        expect(id, greaterThan(0));
      });
      test('on fail throw exception', () {
        final item = ReceiptItemsCompanion(
          receiptId: Value(invalidId),
          price: Value(price),
          itemName: Value(itemName),
        );

        expect(
          () async => await repository.add(item),
          throwsA(isA<Exception>()),
        );
      });
    });

    group('update', () {
      test('updates both price and itemName', () async {
        final item = ReceiptItem(
          id: receiptItemId1,
          receiptId: receiptItemsCompanion1.receiptId.value,
          price: updatedPrice,
          itemName: updatedItemName,
        );

        await repository.update(item);
        final itemFromDb = await repository.getById(receiptItemId1);

        expect(itemFromDb, isA<ReceiptItem>());
        expect(itemFromDb!.price, equals(updatedPrice));
        expect(itemFromDb.itemName, equals(updatedItemName));
      });
      test('returns true on success update', () async {
        final item = ReceiptItem(
          id: receiptItemId1,
          receiptId: receiptItemsCompanion1.receiptId.value,
          price: receiptItemsCompanion1.price.value,
          itemName: receiptItemsCompanion1.itemName.value,
        );

        final wasUpdated = await repository.update(item);
        expect(wasUpdated, equals(true));
      });

      test('returns false on failed update when wrong id provided', () async {
        ReceiptItem item = ReceiptItem(
          id: invalidId,
          receiptId: receiptId1,
          price: price,
          itemName: itemName,
        );

        final wasUpdated = await repository.update(item);
        expect(wasUpdated, false);
      });
    });

    group('getAll', () {
      test('returns a list of all elements', () async {
        final items = await repository.getAll();
        expect(items.length, equals(2));
      });
    });

    group('getByReceiptId', () {
      test('returns a list of all elements with the given receiptId', () async {
        final items = await repository.getByReceiptId(receiptId1);
        expect(items.length, equals(1));
        expect(items[0].id, equals(receiptItemId1));
      });

      test('return empty list on wrong id', () async {
        final items = await repository.getByReceiptId(invalidId);
        expect(items.length, equals(0));
      });
    });

    group('getById', () {
      test('return correct element on good id', () async {
        final fromDb = await repository.getById(receiptItemId1);
        expect(fromDb, isNot(null));
        expect(fromDb!.id, equals(receiptItemId1));
        expect(fromDb.price, equals(receiptItemsCompanion1.price.value));
        expect(fromDb.itemName, equals(receiptItemsCompanion1.itemName.value));
      });

      test('return null on bad id', () async {
        final item = await repository.getById(invalidId);
        expect(item, equals(null));
      });
    });

    group('remove', () {
      test('removes the item given the id', () async {
        final initialCount = await repository.getTotalItemsCount();
        await repository.remove(receiptItemId1);

        final count = await repository.getTotalItemsCount();
        expect(count, equals(initialCount - 1));
      });
    });

    group('getTotalItemsCount', () {
      test('returns the total items', () async {
        final count = await repository.getTotalItemsCount();
        expect(count, equals(2));
      });
    });
  });
}
