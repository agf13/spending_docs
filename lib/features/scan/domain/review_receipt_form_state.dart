import 'package:spending_docs/features/receipt_items/domain/receipt_item_validator.dart';
import 'package:spending_docs/features/receipts/domain/validators/receipt_validator.dart';

class ReviewReceiptItemState {
  String price;
  String itemName;

  ReviewReceiptItemState({this.price = '', this.itemName = ''});

  /*
    Returns false if either price or itemName is not valid. Otherwise returns true.
  */
  bool isValid() {
    ReceiptItemValidationStatus status = ReceiptItemValidator.validateItemName(
      itemName,
    );
    if (status == ReceiptItemValidationStatus.success) {
      status = ReceiptItemValidator.validatePrice(price);
    }

    return status == ReceiptItemValidationStatus.success;
  }
}

class ReviewReceiptFormState {
  String amount;
  String date;
  String storeName;
  String card;

  List<ReviewReceiptItemState> items = [];

  ReviewReceiptFormState({
    this.amount = '',
    this.date = '',
    this.storeName = '',
    this.card = '',
  });

  /*
    Returns null if all fields are valid.
    Returns the index if an item from the list is invalid
    Returns -1,-2,-3,-4 to their respective amount, date, storeName, card if any is invalid 
  */
  int? firstInvalid() {
    if (ReceiptValidator.validateAmount(amount) != .success) {
      return -1;
    }

    if (ReceiptValidator.validateDate(date) != .success) {
      return -2;
    }

    if (ReceiptValidator.validateStoreName(storeName) != .success) {
      return -3;
    }

    if (ReceiptValidator.validateCard(card) != .success) {
      return -4;
    }

    for (int index = 0; index < items.length; index++) {
      if (items[index].isValid() == false) {
        return index;
      }
    }

    // Check for consistency, otherwise point to amount;
    if (!_consistencyCheck()) {
      return -1;
    }

    return null;
  }

  /*
    Checks if the sum of all prices from items is the same as the given amount.
    Assumes firstInvalid is null when this function is called!
  */
  bool _consistencyCheck() {
    final declaredTotal = double.parse(amount);

    double totalSum = itemPriceSum()!;
    const coefficient = 1000000;
    totalSum =
        (totalSum * coefficient).round() /
        coefficient; // Avoid weird double approximations

    return totalSum == declaredTotal;
  }

  /*
    Return the sum of all items. Ignore amount as that is part of the receipt's header.
  */
  double? itemPriceSum() {
    double totalSum = 0;

    for (final item in items) {
      final double? element = double.tryParse(item.price);
      if (element == null) return null;

      totalSum += element;
    }

    return totalSum;
  }
}
