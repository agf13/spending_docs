// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get language => 'English';

  @override
  String get helloWorld => 'Hello World!';

  @override
  String get multiLanguage => 'Multi language';

  @override
  String get homeTitle => 'Home';

  @override
  String get homeDataFetchError => 'Error loading data';

  @override
  String get appBarNavigationHome => 'Home';

  @override
  String get appBarNavigationScan => 'Scan';

  @override
  String get appBarNavigationSearch => 'Search';

  @override
  String get receiptCardMenuEdit => 'Edit';

  @override
  String get receiptCardMenuDelete => 'Delete';

  @override
  String get newReceiptFromTitle => 'New Receipt';

  @override
  String get newReceiptFormSubtitle => 'Log a new receipt in seconds';

  @override
  String get newReceiptFormLabelStoreName => 'Store name';

  @override
  String get newReceiptFormLabelAmount => 'Amount';

  @override
  String get newReceiptFormLabelDate => 'Date';

  @override
  String get newReceiptFormLabelCardOrCash => 'Card or cash';

  @override
  String get newReceiptFormCancel => 'Cancel';

  @override
  String get newReceiptFormHintStoreName => 'Supermarket BuyOnSale';

  @override
  String get newReceiptFormHintAmount => '123.45';

  @override
  String get newReceiptFormHintDate => '...';

  @override
  String get newReceiptFormHintCardOrCash => '1234';

  @override
  String get newReceiptFormSave => 'Save';

  @override
  String get newReceiptFormValidateAmountNotANumber => 'Should be a number';

  @override
  String get newReceiptFormValidateCardInvalidCardValue =>
      'Should be exactly 4 digits or the word \'cash\'';

  @override
  String get newReceiptFormValidateCardInvalidCardNumber =>
      'Should only contain 4 digits or the word \'cash\'';

  @override
  String get newReceiptFromValidateUnexpectedCase => 'Unexpected case';

  @override
  String get newReceiptFormValidateDateDateNotChosen => 'Please chose a date';

  @override
  String get newReceiptItemFormValidateAmountNotANumber => 'Should be a number';

  @override
  String get editReceiptFormTitle => 'Edit receipt';

  @override
  String get editReceiptFormSubtitle => 'Edit your receipt details';

  @override
  String get confirmationPopupDeleteReceiptTile => 'Are you sure?';

  @override
  String get confirmationPopupDelete => 'Delete';

  @override
  String get confirmationPopupCancel => 'Cancel';
}
