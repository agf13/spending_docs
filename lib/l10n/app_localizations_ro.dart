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
}
