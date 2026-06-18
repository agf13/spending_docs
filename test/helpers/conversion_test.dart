import 'package:flutter_test/flutter_test.dart';
import 'package:spending_docs/helpers/conversion.dart';

void main() {
  final decimalDoubleText = "12.3";
  final wholeDoubleText = "15";

  final decimalDouble = 12.3;
  final wholeDouble = 15;

  final notANumber = "a";

  final dateText = "2026-06-20 12:00:30";
  final date = DateTime.parse(dateText);

  final invalidDateText = 'yesterday';

  group('Test conversion helper:', () {
    test('Should properly convert string decimal number to double.', () {
      final result = Conversion.textToDouble(decimalDoubleText);
      expect(result, decimalDouble);
    });

    test('Should properly convert string whole number to double.', () {
      final result = Conversion.textToDouble(wholeDoubleText);
      expect(result, wholeDouble);
    });

    test('Should return null for not a number as text.', () {
      final result = Conversion.textToDouble(notANumber);
      expect(result, isNull);
    });

    test('Should properly convert date from correct date.', () {
      final result = Conversion.textToDateTime(dateText);
      expect(result, date);
    });

    test('Should return null when invalid date provided.', () {
      final result = Conversion.textToDateTime(invalidDateText);
      expect(result, isNull);
    });
  });
}
