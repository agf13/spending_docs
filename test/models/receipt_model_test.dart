import 'package:flutter_test/flutter_test.dart';
import 'package:spending_docs/models/receipt_model.dart';

void main() {
  // Gourp tests about receipt_model
  final amount = 111.02;
  final date = DateTime.parse("2026-06-20 12:01:00");
  final storeName = 'Carrefour';
  final cardNumber = "0000";

  final defaultStoreName = 'default store';
  final defaultCardNumber = 'unknown';

  final amountAsInt = 1;

  final expectedCsv = '111.02,2026-06-20 12:01:00.000,Carrefour,0000';
  final expectedWithDefaultCsv =
      '111.02,2026-06-20 12:01:00.000,default store,unknown';

  group('Receipt_model test:', () {
    test('Should instantiate properly.', () {
      final receipt = ReceiptModel(
        amount: amount,
        date: date,
        storeName: storeName,
        cardNumber: cardNumber,
      );

      expect(receipt.amount, amount);
      expect(receipt.date, date);
      expect(receipt.storeName, storeName);
      expect(receipt.cardNumber, cardNumber);
    });

    test('Should set the default values properly when not provided.', () {
      final receipt = ReceiptModel(amount: amount, date: date);

      expect(receipt.amount, amount);
      expect(receipt.date, date);
      expect(receipt.storeName, defaultStoreName);
      expect(receipt.cardNumber, defaultCardNumber);
    });

    test(
      'Should set the default values properly when empty string provided.',
      () {
        final receipt = ReceiptModel(
          amount: amount,
          date: date,
          storeName: '',
          cardNumber: '',
        );

        expect(receipt.amount, amount);
        expect(receipt.date, date);
        expect(receipt.storeName, defaultStoreName);
        expect(receipt.cardNumber, defaultCardNumber);
      },
    );

    test('Conversion to double should work fine for parameter "amount".', () {
      final receipt = ReceiptModel(amount: amountAsInt.toDouble(), date: date);

      expect(receipt.amount, amountAsInt.toDouble());
    });
  });

  group('Conversion to CSV:', () {
    test('Should properly convert to CSV.', () {
      final receipt = ReceiptModel(
        amount: amount,
        date: date,
        storeName: storeName,
        cardNumber: cardNumber,
      );

      final csvResult = receipt.toCsv();
      expect(csvResult, expectedCsv);
    });

    test('Should properly convert to CSV with default values', () {
      final receipt = ReceiptModel(amount: amount, date: date);

      final csvResult = receipt.toCsv();
      expect(csvResult, expectedWithDefaultCsv);
    });

    test(
      'Should create non null object when a correct CSV string is given',
      () {
        final receipt = ReceiptModel(amount: amount, date: date);

        final csvResult = receipt.toCsv();
        final receiptFromCsv = ReceiptModel.fromCsv(csvResult);

        expect(receiptFromCsv, isNotNull);
      },
    );

    test(
      'Should create the object back when provided a correct CSV string.',
      () {
        final receipt = ReceiptModel(amount: amount, date: date);

        final csvResult = receipt.toCsv();
        final receiptFromCsv = ReceiptModel.fromCsv(csvResult);

        final csvResultFromCsv = receiptFromCsv!.toCsv();
        expect(csvResultFromCsv, expectedWithDefaultCsv);
      },
    );

    test(
      'Should return null when too less parameters are provided in the CSV string.',
      () {
        final csvString = '100.3,2026-01-13 12:30:02.000,true';
        final receiptFromCsv = ReceiptModel.fromCsv(csvString);

        expect(receiptFromCsv, isNull);
      },
    );

    test(
      'Should return null when too many parameters are provided in the CSV string.',
      () {
        final csvString =
            '100.3,2026-01-13 12:30:02.000,true,default store,unknown,other new parameter';
        final receiptFromCsv = ReceiptModel.fromCsv(csvString);

        expect(receiptFromCsv, isNull);
      },
    );
  });
}
