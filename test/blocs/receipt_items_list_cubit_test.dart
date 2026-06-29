import 'package:bloc_test/bloc_test.dart';
import 'package:drift/drift.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:spending_docs/blocs/receipt_items_list_cubit.dart';
import 'package:spending_docs/blocs/receipt_items_list_state.dart';
import 'package:spending_docs/database/app_database.dart'
    show ReceiptItem, ReceiptItemsCompanion;
import 'package:spending_docs/repositories/receipt_items_repository.dart';

class MockRepository extends Mock implements ReceiptItemsRepository {}

final List<ReceiptItem> emptyList = <ReceiptItem>[];

final ReceiptItem item1 = ReceiptItem(
  id: 1,
  receiptId: 1,
  price: 123.0,
  itemName: 'item',
);
final ReceiptItem item2 = ReceiptItem(
  id: 1,
  receiptId: 1,
  price: 123.0,
  itemName: 'item',
);
final List<ReceiptItem> list = [item1, item2];

const genericError = 'did not work';
const genericExceptionMessage = 'Exception: $genericError';

final receiptItemCompanion = ReceiptItemsCompanion(
  receiptId: Value(1),
  price: Value(123.0),
  itemName: Value('item'),
);

void main() {
  late ReceiptItemsListCubit cubit;
  late ReceiptItemsRepository repository;

  setUp(() {
    repository = MockRepository();
    cubit = ReceiptItemsListCubit(repository);
  });

  tearDown(() {
    cubit.close();
  });

  group('ReceiptItemsListCubit', () {
    group('getItems', () {
      blocTest(
        'emits ReceiptItemsListReady with list of items on successfull retrieve',
        build: () {
          when(() => repository.getAll()).thenAnswer((_) async => list);
          return cubit;
        },
        act: (_) {
          cubit.getItems();
        },
        expect: () => [ReceiptItemsListReady(list)],
      );

      blocTest(
        'emits ReceiptItemsListError on error',
        build: () {
          when(() => repository.getAll()).thenThrow(Exception(genericError));
          return cubit;
        },
        act: (_) {
          cubit.getItems();
        },
        expect: () => [ReceiptItemsListError(genericExceptionMessage)],
      );
    });

    group('addItem', () {
      blocTest(
        'emits ReceiptItemsListReady with new list of items on successful add',
        build: () {
          when(
            () => repository.add(receiptItemCompanion),
          ).thenAnswer((_) async => 1);
          when(() => repository.getAll()).thenAnswer((_) async => list);
          return cubit;
        },
        act: (_) {
          cubit.addItem(receiptItemCompanion);
        },
        expect: () => [ReceiptItemsListReady(list)],
      );

      blocTest(
        'emits ReceiptitemsListError on error at add',
        build: () {
          when(
            () => repository.add(receiptItemCompanion),
          ).thenThrow(Exception(genericError));
          return cubit;
        },
        act: (_) {
          cubit.addItem(receiptItemCompanion);
        },
        expect: () => [ReceiptItemsListError(genericExceptionMessage)],
      );
    });

    group('removeItem', () {
      blocTest(
        'emits ReceiptItemsListReady with updated list on successfull remove',
        build: () {
          when(() => repository.remove(1)).thenAnswer((_) async => 1);
          when(() => repository.getAll()).thenAnswer((_) async => list);
          return cubit;
        },
        act: (_) {
          cubit.removeItem(1);
        },
        expect: () => [ReceiptItemsListReady(list)],
      );

      blocTest(
        'emits ReceiptItemsListError when the operation errors out',
        build: () {
          when(() => repository.remove(1)).thenThrow(Exception(genericError));
          return cubit;
        },
        act: (_) {
          cubit.removeItem(1);
        },
        expect: () => [ReceiptItemsListError(genericExceptionMessage)],
      );
    });

    group('updateItem', () {
      blocTest(
        'emits ReceiptItemsListReady with the updated list when the operation succeds',
        build: () {
          when(() => repository.update(item1)).thenAnswer((_) async => true);
          when(() => repository.getAll()).thenAnswer((_) async => list);
          return cubit;
        },
        act: (_) {
          cubit.editItem(item1);
        },
        expect: () => [ReceiptItemsListReady(list)],
      );

      blocTest(
        'emits ReceiptItemsListError when the operation fails with error',
        build: () {
          when(
            () => repository.update(item1),
          ).thenThrow(Exception(genericError));
          return cubit;
        },
        act: (_) {
          cubit.editItem(item1);
        },
        expect: () => [ReceiptItemsListError(genericExceptionMessage)],
      );
    });
  });
}
