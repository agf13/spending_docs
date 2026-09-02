// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Romanian Moldavian Moldovan (`ro`).
class AppLocalizationsRo extends AppLocalizations {
  AppLocalizationsRo([String locale = 'ro']) : super(locale);

  @override
  String get language => 'Romana';

  @override
  String get helloWorld => 'Salut lume!';

  @override
  String get multiLanguage => 'Limbi multiple';

  @override
  String get homeTitle => 'Acasa';

  @override
  String get homeDataFetchError => 'Eroare la incarcarea datelor';

  @override
  String get appBarNavigationHome => 'Acasa';

  @override
  String get appBarNavigationScan => 'Scaneaza';

  @override
  String get appBarNavigationSearch => 'Cauta';

  @override
  String get receiptCardMenuEdit => 'Editeaza';

  @override
  String get receiptCardMenuDelete => 'Sterge';

  @override
  String get newReceiptFromTitle => 'Bon nou';

  @override
  String get newReceiptFormSubtitle => 'Adauga un nou bon in cateva secunde';

  @override
  String get newReceiptFormLabelStoreName => 'Magazin';

  @override
  String get newReceiptFormLabelAmount => 'Total';

  @override
  String get newReceiptFormLabelDate => 'Data';

  @override
  String get newReceiptFormLabelCardOrCash => 'Card sau cash';

  @override
  String get newReceiptFormCancel => 'Anuleaza';

  @override
  String get newReceiptFormHintStoreName => 'Supermarket';

  @override
  String get newReceiptFormHintAmount => '123.45';

  @override
  String get newReceiptFormHintDate => '...';

  @override
  String get newReceiptFormHintCardOrCash => '1234';

  @override
  String get newReceiptFormSave => 'Salveaza';

  @override
  String get newReceiptFormValidateAmountNotANumber =>
      'Trebuie sa fie un numar';

  @override
  String get newReceiptFormValidateCardInvalidCardValue =>
      'Trebuie sa aiba 4 cifre sau cuvantul \'cash\'';

  @override
  String get newReceiptFormValidateCardInvalidCardNumber =>
      'Trebuie sa aiba 4 cifre sau cuvantul \'cash\'';

  @override
  String get newReceiptFromValidateUnexpectedCase => 'Eroare neasteptata';

  @override
  String get newReceiptFormValidateDateDateNotChosen => 'Alege o data';

  @override
  String get editReceiptFormTitle => 'Editeaza bon';

  @override
  String get editReceiptFormSubtitle => 'Aici poti edita bonul';

  @override
  String get confirmationPopupDeleteReceiptTile => 'Are you sure?';

  @override
  String get confirmationPopupDelete => 'Sterge';

  @override
  String get confirmationPopupCancel => 'Renunta';
}
