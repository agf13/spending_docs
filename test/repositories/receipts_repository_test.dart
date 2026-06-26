import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:spending_docs/database/app_database.dart';
import 'package:spending_docs/repositories/receipts_repository.dart';

final nowDate = DateTime.now();

const amount = 100.0;
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
final receiptCompanion = ReceiptsCompanion(
  amount: Value(amount),
  date: Value(date),
  storeName: Value(storeName),
  card: Value(card),
);

const updatedAmount = 99.0;
final updatedDate = DateTime(
  nowDate.year + 1,
  nowDate.month,
  nowDate.day,
  nowDate.hour,
  nowDate.minute,
  nowDate.second,
);
const updatedStoreName = 'storeUpdates';
const updatedCard = '0000';

const invalidId = 1000;
final textWith150Chars =
    'aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa';
final textWith151Chars =
    'aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa';
final textWith4Chars = 'aaaa';
final textWith5Chars = 'aaaaa';

void main() {
  late AppDatabase db;
  late ReceiptsRepository repository;

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
    repository = ReceiptsRepository(db);
  });

  tearDown(() async {
    await db.close();
  });

  group('Test the ReceiptsRepository', () {
    group('getTotalItemsCount', () {
      test('Starts with 0 items', () async {
        final numberOfItems = await repository.getTotalItemsCount();

        expect(numberOfItems, equals(0));
      });

      test('After one insert we have 1 element', () async {
        await insertOneItem(repository, receiptCompanion);
        final numberOfItems = await repository.getTotalItemsCount();

        expect(numberOfItems, equals(1));
      });

      test('After two inserts we have 2 elements', () async {
        await insertOneItem(repository, receiptCompanion);
        await insertOneItem(repository, receiptCompanion);
        final numberOfItems = await repository.getTotalItemsCount();

        expect(numberOfItems, equals(2));
      });
    });

    group('insert function', () {
      test('Add returns correct id', () async {
        final id = await repository.add(receiptCompanion);
        final idFromDb = (await repository.getById(id))?.id;

        expect(id, equals(idFromDb));
      });

      test('Add with invalid object because too long card', () async {
        final invalidReceipt = ReceiptsCompanion(
          amount: Value(amount),
          date: Value(date),
          storeName: Value(storeName),
          card: Value(textWith5Chars),
        );

        expect(() async {
          await repository.add(invalidReceipt);
        }, throwsA(isA<Exception>()));
      });

      test('Add with invalid object because too long store name', () async {
        final invalidReceipt = ReceiptsCompanion(
          amount: Value(amount),
          date: Value(date),
          storeName: Value(textWith151Chars),
          card: Value(card),
        );

        expect(() async {
          await repository.add(invalidReceipt);
        }, throwsA(isA<Exception>()));
      });

      test('bad app does not insert', () async {
        final invalidReceipt = ReceiptsCompanion(
          amount: Value(amount),
          date: Value(date),
          storeName: Value(textWith151Chars),
          card: Value(card),
        );

        expect(() async {
          await repository.add(invalidReceipt);
        }, throwsA(isA<Exception>()));

        final count = await repository.getTotalItemsCount();
        expect(count, equals(0));
      });
    });

    group('getById', () {
      test('The getById function works correctly', () async {
        final id = await insertOneItem(repository, receiptCompanion);
        final receiptFromDb = await repository.getById(id);

        checkAllFields(receiptFromDb!, receiptCompanion, id);
      });

      test('Function getById return null when invalid id is used', () async {
        final receipt = await repository.getById(invalidId);
        expect(receipt, equals(null));
      });
    });

    group('getAll', () {
      test('The getAll function returns all receipts', () async {
        List<int> idList = [];
        idList.add(await insertOneItem(repository, receiptCompanion));
        idList.add(await insertOneItem(repository, receiptCompanion));

        final receipts = await repository.getAll();

        for (int i = 0; i < receipts.length; i++) {
          checkAllFields(receipts[i], receiptCompanion, idList[i]);
        }
      });
    });

    group('update function', () {
      test('Update function updates correctly', () async {
        final id = await insertOneItem(repository, receiptCompanion);

        final updatedReceipt = Receipt(
          id: id,
          amount: updatedAmount,
          date: updatedDate,
          storeName: updatedStoreName,
          card: updatedCard,
        );

        final didUpdate = await repository.update(updatedReceipt);
        final updatedFromDb = await repository.getById(id);

        expect(didUpdate, equals(true));
        checkAllFieldsWithReceipt(updatedFromDb!, updatedReceipt);
      });

      test('Update function returns true on good update', () async {
        final id = await insertOneItem(repository, receiptCompanion);

        final updatedReceipt = Receipt(
          id: id,
          amount: updatedAmount,
          date: updatedDate,
          storeName: updatedStoreName,
          card: updatedCard,
        );

        final didUpdate = await repository.update(updatedReceipt);
        expect(didUpdate, equals(true));
      });

      test('Update function returns false on update with invalid id', () async {
        await insertOneItem(repository, receiptCompanion);

        final updatedReceipt = Receipt(
          id: invalidId,
          amount: updatedAmount,
          date: updatedDate,
          storeName: updatedStoreName,
          card: updatedCard,
        );

        final didUpdate = await repository.update(updatedReceipt);
        expect(didUpdate, equals(false));
      });

      test('Update function throws on update with invalid storeName', () async {
        final id = await insertOneItem(repository, receiptCompanion);

        final updatedReceipt = Receipt(
          id: id,
          amount: updatedAmount,
          date: updatedDate,
          storeName: textWith151Chars,
          card: updatedCard,
        );

        expect(() async {
          await repository.update(updatedReceipt);
        }, throwsA(isA<Exception>()));
      });

      test('Update function throws on update with invalid card', () async {
        final id = await insertOneItem(repository, receiptCompanion);

        final updatedReceipt = Receipt(
          id: id,
          amount: updatedAmount,
          date: updatedDate,
          storeName: updatedStoreName,
          card: textWith5Chars,
        );

        expect(() async {
          await repository.update(updatedReceipt);
        }, throwsA(isA<Exception>()));
      });

      test(
        'Update function does not update on bad update with good id',
        () async {
          final id = await insertOneItem(repository, receiptCompanion);

          final updatedReceipt = Receipt(
            id: id,
            amount: updatedAmount,
            date: updatedDate,
            storeName: updatedStoreName,
            card: textWith5Chars,
          );

          final receiptFromDb = await repository.getById(id);

          expect(() async {
            await repository.update(updatedReceipt);
          }, throwsA(isA<Exception>()));

          expect(receiptFromDb?.amount, equals(receiptCompanion.amount.value));
          expect(
            receiptFromDb?.storeName,
            equals(receiptCompanion.storeName.value),
          );
          expect(receiptFromDb?.card, equals(receiptCompanion.card.value));
          expect(receiptFromDb?.date, equals(receiptCompanion.date.value));
        },
      );

      test('Update function does not insert on bad update', () async {
        await insertOneItem(repository, receiptCompanion);

        final updatedReceipt = Receipt(
          id: invalidId,
          amount: updatedAmount,
          date: updatedDate,
          storeName: updatedStoreName,
          card: updatedCard,
        );

        final didUpdate = await repository.update(updatedReceipt);
        expect(didUpdate, equals(false));

        final count = await repository.getTotalItemsCount();
        expect(count, equals(1));
      });

      test('Update function does not insert on good update', () async {
        final id = await insertOneItem(repository, receiptCompanion);

        final updatedReceipt = Receipt(
          id: id,
          amount: updatedAmount,
          date: updatedDate,
          storeName: updatedStoreName,
          card: updatedCard,
        );

        final didUpdate = await repository.update(updatedReceipt);
        expect(didUpdate, equals(true));

        final count = await repository.getTotalItemsCount();
        expect(count, equals(1));
      });
    });

    group('Remove function', () {
      test(
        'Expect remove to decrease the number of items when called with valid id',
        () async {
          final id = await insertOneItem(repository, receiptCompanion);
          await repository.remove(id);

          final count = await repository.getTotalItemsCount();
          expect(count, equals(0));
        },
      );

      test('Expect remove to not remove when invalid id is used', () async {
        await insertOneItem(repository, receiptCompanion);
        await repository.remove(invalidId);

        final count = await repository.getTotalItemsCount();
        expect(count, equals(1));
      });
    });
  });
}

/*
  Helper functions
*/
Future<int> getNumberOfItems(ReceiptsRepository repository) async {
  return (await repository.getAll()).length;
}

Future<int> insertOneItem(
  ReceiptsRepository repository,
  ReceiptsCompanion receipt,
) {
  return repository.add(receipt);
}

void checkAllFields(
  Receipt receipt1,
  ReceiptsCompanion receipt2,
  int idReceipt2,
) {
  expect(receipt1.id, equals(idReceipt2));
  expect(receipt1.amount, equals(receipt2.amount.value));
  expect(receipt1.date, equals(receipt2.date.value));
  expect(receipt1.storeName, equals(receipt2.storeName.value));
  expect(receipt1.card, equals(receipt2.card.value));
}

void checkAllFieldsWithReceipt(Receipt receipt1, Receipt receipt2) {
  expect(receipt1.id, equals(receipt2.id));
  expect(receipt1.amount, equals(receipt2.amount));
  expect(receipt1.date, equals(receipt2.date));
  expect(receipt1.storeName, equals(receipt2.storeName));
  expect(receipt1.card, equals(receipt2.card));
}
