import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:spending_docs/database/app_database.dart';
import 'package:spending_docs/database/daos/receipts_dao.dart';

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
const updatedAmount = 1.0;
const updatedStoreName = 'updated';
const updatedCard = '0000';
final updatedDate = DateTime(
  dateNow.year + 1,
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

final receiptCompanion = ReceiptsCompanion(
  amount: Value(amount),
  date: Value(date),
  storeName: Value(storeName),
  card: Value(card),
);

final receiptCompanionNoAmount = ReceiptsCompanion(
  amount: Value.absent(),
  date: Value(date),
  storeName: Value(storeName),
  card: Value(card),
);

final receiptCompanionNoDate = ReceiptsCompanion(
  amount: Value(amount),
  date: Value.absent(),
  storeName: Value(storeName),
  card: Value(card),
);

final receiptCompanionNoStoreName = ReceiptsCompanion(
  amount: Value(amount),
  date: Value(date),
  storeName: Value.absent(),
  card: Value(card),
);

final receiptCompanionNoCard = ReceiptsCompanion(
  amount: Value(amount),
  date: Value(date),
  storeName: Value(storeName),
  card: Value.absent(),
);

final receiptCompanionMaximumLengthStoreName = ReceiptsCompanion(
  amount: Value(amount),
  date: Value(date),
  storeName: Value(textWith150Chars),
  card: Value(card),
);

final receiptCompanionTooLongStoreName = ReceiptsCompanion(
  amount: Value(amount),
  date: Value(date),
  storeName: Value(textWith151Chars),
  card: Value(card),
);

final receiptCompanionMaximumLengthCard = ReceiptsCompanion(
  amount: Value(amount),
  date: Value(date),
  storeName: Value(storeName),
  card: Value(textWith4Chars),
);

final receiptCompanionTooLongCard = ReceiptsCompanion(
  amount: Value(amount),
  date: Value(date),
  storeName: Value(storeName),
  card: Value(textWith5Chars),
);

// Main testing function
void main() {
  late AppDatabase db;
  late ReceiptsDao dao;

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
    dao = ReceiptsDao(db);
  });

  tearDown(() {
    dao.close();
    db.close();
  });

  group('ReceiptsDao', () {
    group('insertReceipt', () {
      test('is successfull with correct data', () async {
        final id = await dao.insertReceipt(receiptCompanion);
        final fromDb = await dao.getById(id);

        expect(fromDb, isNot(null));
        expect(fromDb!.amount, equals(amount));
        expect(fromDb.date, equals(date));
        expect(fromDb.storeName, equals(storeName));
        expect(fromDb.card, equals(card));
      });

      test('throws error when amount not provided', () async {
        expect(() async {
          await dao.insertReceipt(receiptCompanionNoAmount);
        }, throwsA(isA<Exception>()));
      });

      test('throws error when date not provided', () async {
        expect(() async {
          await dao.insertReceipt(receiptCompanionNoDate);
        }, throwsA(isA<Exception>()));
      });

      test('is successfull when storeName is not provided', () async {
        final id = await dao.insertReceipt(receiptCompanionNoStoreName);
        final fromDb = await dao.getById(id);

        expect(fromDb, isNot(null));
        expect(fromDb!.amount, equals(amount));
        expect(fromDb.date, equals(date));
        expect(fromDb.card, equals(card));
      });

      test('is successfull when card is not provided', () async {
        final id = await dao.insertReceipt(receiptCompanionNoCard);
        final fromDb = await dao.getById(id);

        expect(fromDb, isNot(null));
        expect(fromDb!.amount, equals(amount));
        expect(fromDb.storeName, equals(storeName));
        expect(fromDb.date, equals(date));
      });

      test('is successfull when card is max length', () async {
        final id = await dao.insertReceipt(receiptCompanionMaximumLengthCard);
        final fromDb = await dao.getById(id);

        expect(fromDb, isNot(null));
        expect(fromDb!.amount, equals(amount));
        expect(fromDb.storeName, equals(storeName));
        expect(fromDb.date, equals(date));
        expect(fromDb.card, equals(textWith4Chars));
      });

      test('is successfull when storeName is max length', () async {
        final id = await dao.insertReceipt(
          receiptCompanionMaximumLengthStoreName,
        );
        final fromDb = await dao.getById(id);

        expect(fromDb, isNot(null));
        expect(fromDb!.amount, equals(amount));
        expect(fromDb.storeName, equals(textWith150Chars));
        expect(fromDb.date, equals(date));
        expect(fromDb.card, equals(card));
      });

      test('throws when card is too long', () async {
        expect(
          () async => await dao.insertReceipt(receiptCompanionTooLongCard),
          throwsA(isA<Exception>()),
        );
      });

      test('throws when storeName is too long', () async {
        expect(
          () async => await dao.insertReceipt(receiptCompanionTooLongStoreName),
          throwsA(isA<Exception>()),
        );
      });
    });

    group('getAllReceipts', () {
      test('returns empty list when no object', () async {
        final items = await dao.getAllReceipts();

        expect(items.length, equals(0));
      });

      test('fetches and returns the items', () async {
        final id1 = await dao.insertReceipt(receiptCompanion);
        final id2 = await dao.insertReceipt(receiptCompanion);
        final items = await dao.getAllReceipts();

        expect(items[0].id, equals(id1));
        expect(items[0].amount, equals(amount));
        expect(items[0].date, equals(date));
        expect(items[0].storeName, equals(storeName));
        expect(items[0].card, equals(card));

        expect(items[1].id, equals(id2));
        expect(items[1].amount, equals(amount));
        expect(items[1].date, equals(date));
        expect(items[1].storeName, equals(storeName));
        expect(items[1].card, equals(card));
      });
    });

    group('updateReceipts', () {
      test('updates correctly all fields', () async {
        final idToUpdate = await dao.insertReceipt(receiptCompanion);
        final updatedReceipt = Receipt(
          id: idToUpdate,
          amount: updatedAmount,
          date: updatedDate,
          storeName: updatedStoreName,
          card: updatedCard,
        );

        await dao.updateReceipt(updatedReceipt);
        final updatedReceiptFromDb = await dao.getById(idToUpdate);

        expect(updatedReceiptFromDb, isA<Receipt>());
        expect(updatedReceiptFromDb!.id, equals(idToUpdate));
        expect(updatedReceiptFromDb.amount, equals(updatedAmount));
        expect(updatedReceiptFromDb.date, equals(updatedDate));
        expect(updatedReceiptFromDb.storeName, equals(updatedStoreName));
        expect(updatedReceiptFromDb.card, equals(updatedCard));
      });

      test('successfull update returns true', () async {
        final idToUpdate = await dao.insertReceipt(receiptCompanion);
        final updatedReceipt = Receipt(
          id: idToUpdate,
          amount: updatedAmount,
          date: updatedDate,
          storeName: updatedStoreName,
          card: updatedCard,
        );

        final wasUpdated = await dao.updateReceipt(updatedReceipt);

        expect(wasUpdated, equals(true));
      });

      test('update with wrong id returns false', () async {
        final updatedReceipt = Receipt(
          id: -1,
          amount: updatedAmount,
          date: updatedDate,
          storeName: updatedStoreName,
          card: updatedCard,
        );

        final wasUpdated = await dao.updateReceipt(updatedReceipt);

        expect(wasUpdated, equals(false));
      });

      test('update with too long store name throws', () async {
        final updatedReceipt = Receipt(
          id: -1,
          amount: updatedAmount,
          date: updatedDate,
          storeName: textWith151Chars,
          card: updatedCard,
        );

        expect(
          () async => await dao.updateReceipt(updatedReceipt),
          throwsA(isA<Exception>()),
        );
      });

      test('update with too long card throws', () async {
        final updatedReceipt = Receipt(
          id: -1,
          amount: updatedAmount,
          date: updatedDate,
          storeName: storeName,
          card: textWith5Chars,
        );

        expect(
          () async => await dao.updateReceipt(updatedReceipt),
          throwsA(isA<Exception>()),
        );
      });
    });

    group('deleteReceipt', () {
      test('removes the entry deleted', () async {
        final id = await dao.insertReceipt(receiptCompanion);
        await dao.deleteReceipt(id);

        final retrievedItem = await dao.getById(id);
        expect(retrievedItem, equals(null));
      });

      test('returns the deleted id', () async {
        final id = await dao.insertReceipt(receiptCompanion);
        final deletedId = await dao.deleteReceipt(id);

        expect(deletedId, equals(id));
      });

      test('returns 0 when using wrong id', () async {
        await dao.insertReceipt(receiptCompanion);
        final deletedId = await dao.deleteReceipt(-1);

        expect(deletedId, equals(0));
      });
    });

    group('getById', () {
      test('returns the correct receipt', () async {
        final id = await dao.insertReceipt(receiptCompanion);
        final receiptFromDb = await dao.getById(id);

        expect(receiptFromDb, isA<Receipt>());
        expect(receiptFromDb!.amount, equals(receiptCompanion.amount.value));
        expect(receiptFromDb.date, equals(receiptCompanion.date.value));
        expect(
          receiptFromDb.storeName,
          equals(receiptCompanion.storeName.value),
        );
        expect(receiptFromDb.card, equals(receiptCompanion.card.value));
        expect(receiptFromDb.id, equals(id));
      });

      test('returns null when trying to retrieve unexistent id', () async {
        final receiptFromDb = await dao.getById(-1);
        expect(receiptFromDb, equals(null));
      });
    });

    group('getTotalItemsCound', () {
      test('returns 0 when no items', () async {
        final count = await dao.getTotalItemsCount();
        expect(count, equals(0));
      });

      test('increments the number of items when they are inserted', () async {
        final count1 = await dao.getTotalItemsCount();
        await dao.insertReceipt(receiptCompanion);
        final count2 = await dao.getTotalItemsCount();

        expect(count2, equals(count1 + 1));
      });
    });
  });
}
