import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_ro.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('ro'),
  ];

  /// The current language
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get language;

  /// A programmer's greeting
  ///
  /// In en, this message translates to:
  /// **'Hello World!'**
  String get helloWorld;

  /// App title
  ///
  /// In en, this message translates to:
  /// **'Multi language'**
  String get multiLanguage;

  /// No description provided for @homeTitle.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get homeTitle;

  /// No description provided for @homeDataFetchError.
  ///
  /// In en, this message translates to:
  /// **'Error loading data'**
  String get homeDataFetchError;

  /// No description provided for @appBarNavigationHome.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get appBarNavigationHome;

  /// No description provided for @appBarNavigationScan.
  ///
  /// In en, this message translates to:
  /// **'Scan'**
  String get appBarNavigationScan;

  /// No description provided for @appBarNavigationSearch.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get appBarNavigationSearch;

  /// No description provided for @receiptCardMenuEdit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get receiptCardMenuEdit;

  /// No description provided for @receiptCardMenuDelete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get receiptCardMenuDelete;

  /// No description provided for @newReceiptFromTitle.
  ///
  /// In en, this message translates to:
  /// **'New Receipt'**
  String get newReceiptFromTitle;

  /// No description provided for @newReceiptFormSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Log a new receipt in seconds'**
  String get newReceiptFormSubtitle;

  /// No description provided for @newReceiptFormLabelStoreName.
  ///
  /// In en, this message translates to:
  /// **'Store name'**
  String get newReceiptFormLabelStoreName;

  /// No description provided for @newReceiptFormLabelAmount.
  ///
  /// In en, this message translates to:
  /// **'Amount'**
  String get newReceiptFormLabelAmount;

  /// No description provided for @newReceiptFormLabelDate.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get newReceiptFormLabelDate;

  /// No description provided for @newReceiptFormLabelCardOrCash.
  ///
  /// In en, this message translates to:
  /// **'Card or cash'**
  String get newReceiptFormLabelCardOrCash;

  /// No description provided for @newReceiptFormCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get newReceiptFormCancel;

  /// No description provided for @newReceiptFormHintStoreName.
  ///
  /// In en, this message translates to:
  /// **'Supermarket BuyOnSale'**
  String get newReceiptFormHintStoreName;

  /// No description provided for @newReceiptFormHintAmount.
  ///
  /// In en, this message translates to:
  /// **'123.45'**
  String get newReceiptFormHintAmount;

  /// No description provided for @newReceiptFormHintDate.
  ///
  /// In en, this message translates to:
  /// **'...'**
  String get newReceiptFormHintDate;

  /// No description provided for @newReceiptFormHintCardOrCash.
  ///
  /// In en, this message translates to:
  /// **'1234'**
  String get newReceiptFormHintCardOrCash;

  /// No description provided for @newReceiptFormSave.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get newReceiptFormSave;

  /// No description provided for @newReceiptFormValidateAmountNotANumber.
  ///
  /// In en, this message translates to:
  /// **'Should be a number'**
  String get newReceiptFormValidateAmountNotANumber;

  /// No description provided for @newReceiptFormValidateCardInvalidCardValue.
  ///
  /// In en, this message translates to:
  /// **'Should be exactly 4 digits or the word \'cash\''**
  String get newReceiptFormValidateCardInvalidCardValue;

  /// No description provided for @newReceiptFormValidateCardInvalidCardNumber.
  ///
  /// In en, this message translates to:
  /// **'Should only contain 4 digits or the word \'cash\''**
  String get newReceiptFormValidateCardInvalidCardNumber;

  /// No description provided for @newReceiptFromValidateUnexpectedCase.
  ///
  /// In en, this message translates to:
  /// **'Unexpected case'**
  String get newReceiptFromValidateUnexpectedCase;

  /// No description provided for @newReceiptFormValidateDateDateNotChosen.
  ///
  /// In en, this message translates to:
  /// **'Please chose a date'**
  String get newReceiptFormValidateDateDateNotChosen;

  /// No description provided for @editReceiptFormTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit receipt'**
  String get editReceiptFormTitle;

  /// No description provided for @editReceiptFormSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Edit your receipt details'**
  String get editReceiptFormSubtitle;

  /// No description provided for @confirmationPopupDeleteReceiptTile.
  ///
  /// In en, this message translates to:
  /// **'Are you sure?'**
  String get confirmationPopupDeleteReceiptTile;

  /// No description provided for @confirmationPopupDelete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get confirmationPopupDelete;

  /// No description provided for @confirmationPopupCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get confirmationPopupCancel;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'ro'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'ro':
      return AppLocalizationsRo();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
