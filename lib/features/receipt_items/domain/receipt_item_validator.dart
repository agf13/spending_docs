enum ReceiptItemValidationStatus { success, notANumber }

class ReceiptItemValidator {
  static ReceiptItemValidationStatus validateItemName(String itemName) {
    return ReceiptItemValidationStatus.success;
  }

  static ReceiptItemValidationStatus validatePrice(String priceString) {
    // Amount should be a proper number
    final price = double.tryParse(priceString);
    if (price == null) return ReceiptItemValidationStatus.notANumber;

    // Any number is a success
    return ReceiptItemValidationStatus.success;
  }
}
