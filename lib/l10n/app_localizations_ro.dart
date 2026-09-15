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
  String get homeEasterEggTitle => 'easter egg title';

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
  String get newReceiptItemFormValidateAmountNotANumber =>
      'Trebuie sa fie un numar';

  @override
  String get editReceiptFormTitle => 'Editeaza bon';

  @override
  String get editReceiptFormSubtitle => 'Aici poti edita bonul';

  @override
  String get scanReceiptResultFormTitle => 'Verifica scanarea';

  @override
  String get scanReceiptResultFormLabelAmout => 'Total';

  @override
  String get scanReceiptResultFormLabelStoreName => 'Magazin';

  @override
  String get scanReceiptResultFormLabelDate => 'Data';

  @override
  String get scanReceiptResultFormLabelCard => 'Card';

  @override
  String get scanReceiptResultButtonCancel => 'Renunta';

  @override
  String get scanReceiptResultButtonRetry => 'Reincearca';

  @override
  String get scanReceiptResultButtonSave => 'Salveaza';

  @override
  String scanReceiptResultTotalAmountDifferent(
    double scanReceiptResultCalculatedTotal,
  ) {
    return 'Suma preturilor e diferita de total. Totalul este: $scanReceiptResultCalculatedTotal';
  }

  @override
  String get confirmationPopupDeleteReceiptTile => 'Are you sure?';

  @override
  String get confirmationPopupDelete => 'Sterge';

  @override
  String get confirmationPopupCancel => 'Renunta';

  @override
  String get searchScreenTitle => 'Cauta';

  @override
  String get searchScreenTo => 'La';

  @override
  String get searchScreenFrom => 'De la';

  @override
  String get searchScreenStoreName => 'magazin';

  @override
  String get searchScreenAmount => 'total';

  @override
  String get searchScreenDate => 'data';

  @override
  String get searchScreenCard => 'card';

  @override
  String get searchScreenUnknownError =>
      'Eroare neasteptata. Incearca sa redeschizi aplicatia';
}
