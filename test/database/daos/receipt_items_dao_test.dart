import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:spending_docs/database/app_database.dart';
import 'package:spending_docs/database/daos/receipt_items_dao.dart';
import 'package:spending_docs/database/daos/receipts_dao.dart';

/*
  Constants used
*/
const price = 1.0;
const itemName = 'item';

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
ReceiptsCompanion receiptsCompanion = ReceiptsCompanion(
  amount: Value(amount),
  date: Value(date),
  storeName: Value(storeName),
  card: Value(card),
);

const updatedPrice = 1.5;
const updatedItemName = 'updatedItem';

final textWith150Chars =
    'aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa';
final textWith151Chars =
    'aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa';

void main() {
  late AppDatabase db;
  late ReceiptsDao receiptsDao;
  late ReceiptItemsDao receiptItemsDao;
  late int parentReceiptId1, parentReceiptId2;

  setUp(() async {
    db = AppDatabase(NativeDatabase.memory());
    receiptsDao = ReceiptsDao(db);
    receiptItemsDao = ReceiptItemsDao(db);

    parentReceiptId1 = await receiptsDao.insertReceipt(receiptsCompanion);
    parentReceiptId2 = await receiptsDao.insertReceipt(receiptsCompanion);
  });

  tearDown(() {
    receiptsDao.close();
    receiptItemsDao.close();
    db.close();
  });

  group('ReceiptItemsDao', () {
    group('insertReceiptItem', () {
      test('insert works ok', () async {
        final receiptItemsCompanion = ReceiptItemsCompanion(
          receiptId: Value(parentReceiptId1),
          price: Value(price),
          itemName: Value(itemName),
        );
        final id = await receiptItemsDao.insertReceiptItem(
          receiptItemsCompanion,
        );
        final itemFromDb = await receiptItemsDao.getById(id);

        expect(itemFromDb, isA<ReceiptItem>());
        expect(itemFromDb!.id, equals(id));
        expect(itemFromDb.receiptId, equals(parentReceiptId1));
        expect(itemFromDb.price, equals(receiptItemsCompanion.price.value));
        expect(
          itemFromDb.itemName,
          equals(receiptItemsCompanion.itemName.value),
        );
      });

      test('insert with maximum length for itemName works ok', () async {
        final receiptItemsCompanion = ReceiptItemsCompanion(
          receiptId: Value(parentReceiptId1),
          price: Value(price),
          itemName: Value(textWith150Chars),
        );
        final id = await receiptItemsDao.insertReceiptItem(
          receiptItemsCompanion,
        );
        final itemFromDb = await receiptItemsDao.getById(id);

        expect(itemFromDb, isA<ReceiptItem>());
        expect(itemFromDb!.id, equals(id));
        expect(itemFromDb.receiptId, equals(parentReceiptId1));
        expect(itemFromDb.price, equals(receiptItemsCompanion.price.value));
        expect(
          itemFromDb.itemName,
          equals(receiptItemsCompanion.itemName.value),
        );
      });

      test('insert with too long itemName throws error', () async {
        final invalidReceiptItemsCompanion = ReceiptItemsCompanion(
          receiptId: Value(parentReceiptId1),
          price: Value(price),
          itemName: Value(textWith151Chars),
        );

        expect(() async {
          await receiptItemsDao.insertReceiptItem(invalidReceiptItemsCompanion);
        }, throwsA(isA<Exception>()));
      });

      test('insert with unexistend receiptId throws error', () async {
        final invalidReceiptItemsCompanion = ReceiptItemsCompanion(
          receiptId: Value(-1),
          price: Value(price),
          itemName: Value(textWith151Chars),
        );

        expect(() async {
          await receiptItemsDao.insertReceiptItem(invalidReceiptItemsCompanion);
        }, throwsA(isA<Exception>()));
      });

      group('getById', () {
        test('returns correct item', () async {
          final receiptItemsCompanion = ReceiptItemsCompanion(
            receiptId: Value(parentReceiptId1),
            price: Value(price),
            itemName: Value(itemName),
          );
          final id = await receiptItemsDao.insertReceiptItem(
            receiptItemsCompanion,
          );
          final itemFromDb = await receiptItemsDao.getById(id);

          expect(itemFromDb, isA<ReceiptItem>());
          expect(itemFromDb!.id, equals(id));
          expect(itemFromDb.receiptId, equals(parentReceiptId1));
          expect(itemFromDb.price, equals(receiptItemsCompanion.price.value));
          expect(
            itemFromDb.itemName,
            equals(receiptItemsCompanion.itemName.value),
          );
        });

        test('returns null with unexistent it', () async {
          final fromDb = await receiptItemsDao.getById(-1);
          expect(fromDb, equals(null));
        });
      });

      group('getAllReceiptItems', () {
        test('returns empty list when no items stored', () async {
          final items = await receiptItemsDao.getAllReceiptItems();
          expect(items.length, equals(0));
        });

        test('returns all items when multiple', () async {
          final receiptItemsCompanion = ReceiptItemsCompanion(
            receiptId: Value(parentReceiptId1),
            price: Value(price),
            itemName: Value(itemName),
          );

          final id1 = await receiptItemsDao.insertReceiptItem(
            receiptItemsCompanion,
          );
          final id2 = await receiptItemsDao.insertReceiptItem(
            receiptItemsCompanion,
          );

          final items = await receiptItemsDao.getAllReceiptItems();

          expect(items.length, equals(2));

          // Make sure for testing sake that item with id1 is first
          if (items[0].id == id2) {
            final aux = items[0];
            items[0] = items[1];
            items[1] = aux;
          }

          expect(items[0], isA<ReceiptItem>());
          expect(items[0].id, equals(id1));
          expect(items[0].receiptId, equals(parentReceiptId1));
          expect(items[0].price, equals(receiptItemsCompanion.price.value));
          expect(
            items[0].itemName,
            equals(receiptItemsCompanion.itemName.value),
          );

          expect(items[1], isA<ReceiptItem>());
          expect(items[1].id, equals(id2));
          expect(items[1].receiptId, equals(parentReceiptId1));
          expect(items[1].price, equals(receiptItemsCompanion.price.value));
          expect(
            items[1].itemName,
            equals(receiptItemsCompanion.itemName.value),
          );
        });
      });

      group('getAllByReceipt', () {
        test('returns only items related to the receiptId given', () async {
          final receiptItemsCompanion1 = ReceiptItemsCompanion(
            receiptId: Value(parentReceiptId1),
            price: Value(price),
            itemName: Value(itemName),
          );
          final receiptItemsCompanion2 = ReceiptItemsCompanion(
            receiptId: Value(parentReceiptId2),
            price: Value(price),
            itemName: Value(itemName),
          );

          final id1 = await receiptItemsDao.insertReceiptItem(
            receiptItemsCompanion1,
          );
          final id2 = await receiptItemsDao.insertReceiptItem(
            receiptItemsCompanion1,
          );
          final id3 = await receiptItemsDao.insertReceiptItem(
            receiptItemsCompanion2,
          );

          final items = await receiptItemsDao.getAllByReceipt(parentReceiptId1);

          // Make sure id3 is not in the list
          expect(items.length, equals(2));
          expect(items[0].id, isNot(id3));
          expect(items[1].id, isNot(id3));

          // Make sure item with id1 is first
          if (items[0].id == id2) {
            final aux = items[0];
            items[0] = items[1];
            items[1] = aux;
          }

          expect(items[0].id, equals(id1));
          expect(items[1].id, equals(id2));
        });
      });

      group('updateReceiptItem', () {
        test('can update both price and itemName', () async {
          final receiptItemsCompanion = ReceiptItemsCompanion(
            receiptId: Value(parentReceiptId1),
            price: Value(price),
            itemName: Value(itemName),
          );

          final id = await receiptItemsDao.insertReceiptItem(
            receiptItemsCompanion,
          );

          final updatedReceiptItem = ReceiptItem(
            id: id,
            receiptId: parentReceiptId1,
            price: updatedPrice,
            itemName: updatedItemName,
          );

          await receiptItemsDao.updateReceiptItem(updatedReceiptItem);

          final fromDb = await receiptItemsDao.getById(id);

          expect(fromDb, isNot(null));
          expect(fromDb!.price, equals(updatedReceiptItem.price));
          expect(fromDb.itemName, equals(updatedReceiptItem.itemName));
        });

        test('successfull update returns true', () async {
          final receiptItemsCompanion = ReceiptItemsCompanion(
            receiptId: Value(parentReceiptId1),
            price: Value(price),
            itemName: Value(itemName),
          );

          final id = await receiptItemsDao.insertReceiptItem(
            receiptItemsCompanion,
          );

          final updatedReceiptItem = ReceiptItem(
            id: id,
            receiptId: parentReceiptId1,
            price: updatedPrice,
            itemName: updatedItemName,
          );

          final wasUpdated = await receiptItemsDao.updateReceiptItem(
            updatedReceiptItem,
          );
          expect(wasUpdated, equals(true));
        });

        test('throws when using wrong receiptId', () async {
          final receiptItemsCompanion = ReceiptItemsCompanion(
            receiptId: Value(parentReceiptId1),
            price: Value(price),
            itemName: Value(itemName),
          );

          final id = await receiptItemsDao.insertReceiptItem(
            receiptItemsCompanion,
          );

          final updatedReceiptItem = ReceiptItem(
            id: id,
            receiptId: -1,
            price: updatedPrice,
            itemName: itemName,
          );

          expect(
            () async =>
                await receiptItemsDao.updateReceiptItem(updatedReceiptItem),
            throwsA(isA<Exception>()),
          );
        });

        test('throws when itemName too long', () async {
          final receiptItemsCompanion = ReceiptItemsCompanion(
            receiptId: Value(parentReceiptId1),
            price: Value(price),
            itemName: Value(itemName),
          );

          final id = await receiptItemsDao.insertReceiptItem(
            receiptItemsCompanion,
          );

          final updatedReceiptItem = ReceiptItem(
            id: id,
            receiptId: parentReceiptId1,
            price: updatedPrice,
            itemName: textWith151Chars,
          );

          expect(
            () async =>
                await receiptItemsDao.updateReceiptItem(updatedReceiptItem),
            throwsA(isA<Exception>()),
          );
        });

        test(
          'unsuccessfull update returns false when using wrong id',
          () async {
            final receiptItemsCompanion = ReceiptItemsCompanion(
              receiptId: Value(parentReceiptId1),
              price: Value(price),
              itemName: Value(itemName),
            );

            await receiptItemsDao.insertReceiptItem(receiptItemsCompanion);

            final updatedReceiptItem = ReceiptItem(
              id: -1,
              receiptId: parentReceiptId1,
              price: updatedPrice,
              itemName: itemName,
            );

            final wasUpdated = await receiptItemsDao.updateReceiptItem(
              updatedReceiptItem,
            );

            expect(wasUpdated, equals(false));
          },
        );
      });

      group('deleteReceiptItem', () {
        test('successfully deletes', () async {
          final receiptItemsCompanion = ReceiptItemsCompanion(
            receiptId: Value(parentReceiptId1),
            price: Value(price),
            itemName: Value(itemName),
          );

          final id = await receiptItemsDao.insertReceiptItem(
            receiptItemsCompanion,
          );
          await receiptItemsDao.deleteReceiptItem(id);

          final fromDb = await receiptItemsDao.getById(id);
          expect(fromDb, equals(null));
        });

        test('returns correct id', () async {
          final receiptItemsCompanion = ReceiptItemsCompanion(
            receiptId: Value(parentReceiptId1),
            price: Value(price),
            itemName: Value(itemName),
          );

          final id = await receiptItemsDao.insertReceiptItem(
            receiptItemsCompanion,
          );
          final deleteId = await receiptItemsDao.deleteReceiptItem(id);

          expect(deleteId, equals(id));
        });

        test('returns 0 when using wrong id', () async {
          final receiptItemsCompanion = ReceiptItemsCompanion(
            receiptId: Value(parentReceiptId1),
            price: Value(price),
            itemName: Value(itemName),
          );

          await receiptItemsDao.insertReceiptItem(receiptItemsCompanion);
          final deleteId = await receiptItemsDao.deleteReceiptItem(-1);

          expect(deleteId, equals(0));
        });
      });

      group('getTotalItemsCount', () {
        test('returns 0 if no items', () async {
          final count = await receiptItemsDao.getTotalItemsCount();
          expect(count, equals(0));
        });

        test('returns correct count if multiple items', () async {
          final receiptItemsCompanion = ReceiptItemsCompanion(
            receiptId: Value(parentReceiptId1),
            price: Value(price),
            itemName: Value(itemName),
          );

          await receiptItemsDao.insertReceiptItem(receiptItemsCompanion);
          await receiptItemsDao.insertReceiptItem(receiptItemsCompanion);

          final count = await receiptItemsDao.getTotalItemsCount();
          expect(count, equals(2));
        });
      });
    });
  });
}
