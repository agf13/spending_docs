import 'package:spending_docs/helpers/conversion.dart';

class ReceiptModel {
  double amount;
  DateTime? date;
  String storeName;
  String cardNumber;

  ReceiptModel({
    required this.amount,
    required this.date,
    this.storeName = 'default store',
    this.cardNumber = 'unknown',
  }) {
    ensureDefaultStoreNameIfEmpty();
    ensureDefaultCardNumberIfEmpty();
  }

  String toCsv() {
    String output = "$amount,${date.toString()},$storeName,$cardNumber";
    return output;
  }

  static ReceiptModel? fromCsv(String line) {
    final attributes = line.split(',');
    if (attributes.length != 4) return null;

    final amount = Conversion.textToDouble(attributes[0]);
    final date = Conversion.textToDateTime(attributes[1]);
    final storeName = attributes[2];
    final cardNumber = attributes[3];

    return ReceiptModel(
      amount: amount!,
      date: date,
      storeName: storeName,
      cardNumber: cardNumber,
    );
  }

  void ensureDefaultStoreNameIfEmpty() {
    if (storeName.isEmpty) storeName = 'default store';
  }

  void ensureDefaultCardNumberIfEmpty() {
    if (cardNumber.isEmpty) cardNumber = 'unknown';
  }

  /*
    def:  For this model is considered that a pair (date - store) is unique.
    in:   ReceiptModel receipt1
          ReceiptModel receipt2
    out:  True - if both models have same date and store name
          False - otherwise
   */
  static bool isSame(ReceiptModel receipt1, ReceiptModel receipt2) {
    return (receipt1.date == receipt2.date &&
        receipt1.storeName == receipt2.storeName);
  }
}
