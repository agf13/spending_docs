enum ReceiptValidationStatus {
  notANumber,
  success,
  invalidCardValue,
  invalidCardNumber,
  dateNotChosen,
}

class ReceiptValidator {
  static ReceiptValidationStatus validateAmount(String amountString) {
    // Amount should be a proper number
    final amount = double.tryParse(amountString);
    if (amount == null) return ReceiptValidationStatus.notANumber;

    // Any number is a success
    return ReceiptValidationStatus.success;
  }

  static ReceiptValidationStatus validateCard(String cardOrCash) {
    // A card is either last 4 digits or the word 'cash'. Both 4 char long
    if (cardOrCash.length != 4) return ReceiptValidationStatus.invalidCardValue;

    // If the value is 'cash' is ok
    if (cardOrCash == 'cash') return ReceiptValidationStatus.success;

    // Value is not 'cash', so it needs to be a number
    final cardAsNumber = int.tryParse(cardOrCash);
    if (cardAsNumber == null) return ReceiptValidationStatus.invalidCardNumber;

    // Any other case is ok
    return ReceiptValidationStatus.success;
  }

  static ReceiptValidationStatus validateStoreName(String storeName) {
    return ReceiptValidationStatus.success;
  }

  static ReceiptValidationStatus validateDate(String date) {
    if (date.isEmpty) return ReceiptValidationStatus.dateNotChosen;
    return ReceiptValidationStatus.success;
  }
}
