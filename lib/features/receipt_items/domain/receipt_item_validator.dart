import 'package:flutter/material.dart' show BuildContext;
import 'package:spending_docs/l10n/app_localizations.dart';

enum ReceiptItemValidationStatus { success, notANumber }

class ReceiptItemValidator {
  static ReceiptItemValidationStatus validateItemName(String itemName) {
    return ReceiptItemValidationStatus.success;
  }

  static String? validateItemNameError(String? itemName, BuildContext context) {
    itemName ??= '';
    ReceiptItemValidationStatus status = validateItemName(itemName);
    if (status == ReceiptItemValidationStatus.success) {
      return null;
    }
    return null;
  }

  static ReceiptItemValidationStatus validatePrice(String priceString) {
    // Amount should be a proper number
    final price = double.tryParse(priceString);
    if (price == null) return ReceiptItemValidationStatus.notANumber;

    // Any number is a success
    return ReceiptItemValidationStatus.success;
  }

  static String? validatePriceError(String? priceString, BuildContext context) {
    priceString ??= '';
    ReceiptItemValidationStatus status = validatePrice(priceString);
    if (status == ReceiptItemValidationStatus.notANumber) {
      return AppLocalizations.of(
        context,
      )?.newReceiptItemFormValidateAmountNotANumber;
    }
    if (status == ReceiptItemValidationStatus.success) {
      return null;
    }
    return null;
  }
}
