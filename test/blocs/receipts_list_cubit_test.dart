import 'package:bloc_test/bloc_test.dart';
import 'package:drift/drift.dart' show Value;
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:spending_docs/blocs/receipts_list_cubit.dart';
import 'package:spending_docs/blocs/receipts_list_state.dart';
import 'package:spending_docs/database/app_database.dart'
    show Receipt, ReceiptsCompanion;
import 'package:spending_docs/repositories/receipts_repository.dart';

class MockRepository extends Mock implements ReceiptsRepository {}

final List<Receipt> emptyList = <Receipt>[];

final Receipt receipt1 = Receipt(id: 1, amount: 123.0, date: DateTime.now());
final Receipt receipt2 = Receipt(id: 2, amount: 123.0, date: DateTime.now());
final List<Receipt> receiptsList = [receipt1, receipt2];

final receiptCompanion = ReceiptsCompanion(
  amount: Value(123.0),
  date: Value(DateTime.now()),
);

void main() {
  late ReceiptsListCubit receiptsListCubit;
  late MockRepository mockRepository;

  setUp(() {
    mockRepository = MockRepository();
    receiptsListCubit = ReceiptsListCubit(mockRepository);
  });

  tearDown(() {
    receiptsListCubit.close();
  });

  group('ReceiptsListCubit tests', () {
    group('at initialization', () {
      test('should have state ReceiptsListInitial', () {
        expect(receiptsListCubit.state, isA<ReceiptsListInitial>());
      });
    });

    group('getItems', () {
      blocTest<ReceiptsListCubit, ReceiptsListState>(
        'returns empty list with no items',
        build: () {
          when(
            () => mockRepository.getAll(),
          ).thenAnswer((_) async => emptyList);
          return receiptsListCubit;
        },
        act: (bloc) {
          receiptsListCubit.getItems();
        },
        expect: () => [ReceiptsListReady([])],
      );

      blocTest<ReceiptsListCubit, ReceiptsListState>(
        'returns error state when getAll() raises an error in repo',
        build: () {
          when(
            () => mockRepository.getAll(),
          ).thenThrow(Exception('Error on retrieve'));
          return receiptsListCubit;
        },
        act: (bloc) {
          receiptsListCubit.getItems();
        },
        expect: () => [ReceiptsListError('Exception: Error on retrieve')],
      );

      blocTest<ReceiptsListCubit, ReceiptsListState>(
        'returns ReceiptsListReady with list of elements correctly',
        build: () {
          when(
            () => mockRepository.getAll(),
          ).thenAnswer((_) async => receiptsList);
          return receiptsListCubit;
        },
        act: (bloc) {
          receiptsListCubit.getItems();
        },
        expect: () => [ReceiptsListReady(receiptsList)],
      );
    });

    group('addItem', () {
      blocTest(
        'returns ReceiptsListError when there is a problem adding',
        build: () {
          when(
            () => mockRepository.add(receiptCompanion),
          ).thenThrow(Exception('cannot add'));

          return receiptsListCubit;
        },
        act: (bloc) {
          receiptsListCubit.addItem(receiptCompanion);
        },
        expect: () => [ReceiptsListError('Exception: cannot add')],
      );

      blocTest(
        'adds successfully',
        build: () {
          when(
            () => mockRepository.add(receiptCompanion),
          ).thenAnswer((_) async => 1);
          when(
            () => mockRepository.getAll(),
          ).thenAnswer((_) async => [receipt1]);

          return receiptsListCubit;
        },
        act: (_) {
          receiptsListCubit.addItem(receiptCompanion);
        },
        expect: () => [
          ReceiptsListReady([receipt1]),
        ],
      );
    });

    group('removeItem', () {
      blocTest(
        'return ReceiptsListReady when removing successfully',
        build: () {
          when(() => mockRepository.remove(1)).thenAnswer((_) async => 1);
          when(
            () => mockRepository.getAll(),
          ).thenAnswer((_) async => emptyList);

          return receiptsListCubit;
        },
        act: (_) {
          receiptsListCubit.removeItem(1);
        },
        expect: () => [ReceiptsListReady(emptyList)],
      );

      blocTest(
        'return ReceiptsListError when remove throws',
        build: () {
          when(
            () => mockRepository.remove(1),
          ).thenThrow(Exception('cannot remove'));

          return receiptsListCubit;
        },
        act: (_) {
          receiptsListCubit.removeItem(1);
        },
        expect: () => [ReceiptsListError('Exception: cannot remove')],
      );
    });

    group('editItem', () {
      blocTest(
        'return ReceiptsListReady when update successfull',
        build: () {
          when(
            () => mockRepository.update(receipt1),
          ).thenAnswer((_) async => true);
          when(
            () => mockRepository.getAll(),
          ).thenAnswer((_) async => [receipt1]);

          return receiptsListCubit;
        },
        act: (_) {
          receiptsListCubit.editItem(receipt1);
        },
        expect: () => [
          ReceiptsListReady([receipt1]),
        ],
      );

      blocTest(
        'return ReceiptsListError when edit throws',
        build: () {
          when(
            () => mockRepository.update(receipt1),
          ).thenThrow(Exception('cannot update'));

          return receiptsListCubit;
        },
        act: (_) {
          receiptsListCubit.editItem(receipt1);
        },
        expect: () => [ReceiptsListError('Exception: cannot update')],
      );
    });
  });
}
