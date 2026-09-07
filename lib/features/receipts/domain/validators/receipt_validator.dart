import 'package:flutter/widgets.dart' show BuildContext;
import 'package:spending_docs/l10n/app_localizations.dart';

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

  static String? validateAmountError(
    String? amountString,
    BuildContext context,
  ) {
    // Amount should be a proper number
    ReceiptValidationStatus status = validateAmount(amountString ?? '');
    if (status == ReceiptValidationStatus.notANumber) {
      return AppLocalizations.of(
        context,
      )?.newReceiptFormValidateAmountNotANumber;
    } else if (status == ReceiptValidationStatus.success) {
      return null;
    }

    return null;
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

  static String? validateCardError(String? cardOrCash, BuildContext context) {
    cardOrCash ??= '';
    ReceiptValidationStatus status = validateCard(cardOrCash);

    if (status == ReceiptValidationStatus.invalidCardNumber) {
      return AppLocalizations.of(
        context,
      )?.newReceiptFormValidateCardInvalidCardNumber;
    } else if (status == ReceiptValidationStatus.invalidCardValue) {
      return AppLocalizations.of(
        context,
      )?.newReceiptFormValidateCardInvalidCardValue;
    } else if (status == ReceiptValidationStatus.success) {
      return null;
    }

    return null;
  }

  static ReceiptValidationStatus validateStoreName(String storeName) {
    return ReceiptValidationStatus.success;
  }

  static String? validateStoreNameError(
    String? storeName,
    BuildContext context,
  ) {
    storeName ??= '';
    ReceiptValidationStatus status = validateStoreName(storeName);
    if (status == ReceiptValidationStatus.success) {
      return null;
    }
    return null;
  }

  static ReceiptValidationStatus validateDate(String date) {
    if (date.isEmpty) return ReceiptValidationStatus.dateNotChosen;
    return ReceiptValidationStatus.success;
  }

  static String? validateDateError(String? date, BuildContext context) {
    date ??= '';
    ReceiptValidationStatus status = validateDate(date);
    if (status == ReceiptValidationStatus.dateNotChosen) {
      return AppLocalizations.of(
        context,
      )?.newReceiptFormValidateDateDateNotChosen;
    } else if (status == ReceiptValidationStatus.success) {
      return null;
    }

    return null;
  }
}
