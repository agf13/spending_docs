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
}
