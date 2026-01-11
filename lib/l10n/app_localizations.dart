import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_fr.dart';

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
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

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
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('fr')
  ];

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'Log In'**
  String get login;

  /// No description provided for @signup.
  ///
  /// In en, this message translates to:
  /// **'Create an account'**
  String get signup;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @confirmPassword.
  ///
  /// In en, this message translates to:
  /// **'Confirm Password'**
  String get confirmPassword;

  /// No description provided for @signInto.
  ///
  /// In en, this message translates to:
  /// **'Sign Into'**
  String get signInto;

  /// No description provided for @manageYourDevice.
  ///
  /// In en, this message translates to:
  /// **'Manage Your Device & Accessory'**
  String get manageYourDevice;

  /// No description provided for @noAccount.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account yet?'**
  String get noAccount;

  /// No description provided for @alreadyHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Already have an account?'**
  String get alreadyHaveAccount;

  /// No description provided for @loggingIn.
  ///
  /// In en, this message translates to:
  /// **'Logging in...'**
  String get loggingIn;

  /// No description provided for @creatingAccount.
  ///
  /// In en, this message translates to:
  /// **'Creating account...'**
  String get creatingAccount;

  /// No description provided for @forgotPassword.
  ///
  /// In en, this message translates to:
  /// **'Forgot password?'**
  String get forgotPassword;

  /// No description provided for @resetPassword.
  ///
  /// In en, this message translates to:
  /// **'Reset Password'**
  String get resetPassword;

  /// No description provided for @sendResetEmail.
  ///
  /// In en, this message translates to:
  /// **'Send Reset Email'**
  String get sendResetEmail;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// No description provided for @send.
  ///
  /// In en, this message translates to:
  /// **'Send'**
  String get send;

  /// No description provided for @enterYourEmail.
  ///
  /// In en, this message translates to:
  /// **'Enter your email'**
  String get enterYourEmail;

  /// No description provided for @resetEmailSent.
  ///
  /// In en, this message translates to:
  /// **'Reset email sent'**
  String get resetEmailSent;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Log Out'**
  String get logout;

  /// No description provided for @welcome.
  ///
  /// In en, this message translates to:
  /// **'Welcome!'**
  String get welcome;

  /// No description provided for @connectedAs.
  ///
  /// In en, this message translates to:
  /// **'Connected as:'**
  String get connectedAs;

  /// No description provided for @createNewAccount.
  ///
  /// In en, this message translates to:
  /// **'Create a new account'**
  String get createNewAccount;

  /// No description provided for @emailRequired.
  ///
  /// In en, this message translates to:
  /// **'Email is required'**
  String get emailRequired;

  /// No description provided for @invalidEmail.
  ///
  /// In en, this message translates to:
  /// **'Invalid email'**
  String get invalidEmail;

  /// No description provided for @passwordRequired.
  ///
  /// In en, this message translates to:
  /// **'Password is required'**
  String get passwordRequired;

  /// No description provided for @passwordTooShort.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 6 characters'**
  String get passwordTooShort;

  /// No description provided for @confirmPasswordRequired.
  ///
  /// In en, this message translates to:
  /// **'Password confirmation is required'**
  String get confirmPasswordRequired;

  /// No description provided for @passwordsDoNotMatch.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match'**
  String get passwordsDoNotMatch;

  /// No description provided for @userNotFound.
  ///
  /// In en, this message translates to:
  /// **'No user found with this email.'**
  String get userNotFound;

  /// No description provided for @wrongPassword.
  ///
  /// In en, this message translates to:
  /// **'Incorrect password.'**
  String get wrongPassword;

  /// No description provided for @emailAlreadyInUse.
  ///
  /// In en, this message translates to:
  /// **'An account already exists with this email.'**
  String get emailAlreadyInUse;

  /// No description provided for @weakPassword.
  ///
  /// In en, this message translates to:
  /// **'Password must contain at least 6 characters.'**
  String get weakPassword;

  /// No description provided for @userDisabled.
  ///
  /// In en, this message translates to:
  /// **'This account has been disabled.'**
  String get userDisabled;

  /// No description provided for @tooManyRequests.
  ///
  /// In en, this message translates to:
  /// **'Too many attempts. Try again later.'**
  String get tooManyRequests;

  /// No description provided for @operationNotAllowed.
  ///
  /// In en, this message translates to:
  /// **'Operation not allowed.'**
  String get operationNotAllowed;

  /// No description provided for @errorOccurred.
  ///
  /// In en, this message translates to:
  /// **'An error occurred'**
  String get errorOccurred;

  /// No description provided for @esp32ConfigurationTitle.
  ///
  /// In en, this message translates to:
  /// **'ESP32 Configuration'**
  String get esp32ConfigurationTitle;

  /// No description provided for @esp32ConnectInstruction.
  ///
  /// In en, this message translates to:
  /// **'Connect to your TTGO T-Display ESP32:'**
  String get esp32ConnectInstruction;

  /// No description provided for @scanQrCode.
  ///
  /// In en, this message translates to:
  /// **'Scan QR Code'**
  String get scanQrCode;

  /// No description provided for @qrScanFailed.
  ///
  /// In en, this message translates to:
  /// **'QR scan failed: {error}'**
  String qrScanFailed(String error);

  /// No description provided for @qrScannerTitle.
  ///
  /// In en, this message translates to:
  /// **'Scan ESP32 QR Code'**
  String get qrScannerTitle;

  /// No description provided for @qrInvalid.
  ///
  /// In en, this message translates to:
  /// **'Invalid QR code: {error}'**
  String qrInvalid(String error);

  /// No description provided for @toggleFlashlight.
  ///
  /// In en, this message translates to:
  /// **'Toggle flashlight'**
  String get toggleFlashlight;

  /// No description provided for @switchCamera.
  ///
  /// In en, this message translates to:
  /// **'Switch camera'**
  String get switchCamera;

  /// No description provided for @qrScannerInstructionTitle.
  ///
  /// In en, this message translates to:
  /// **'Scan the QR code shown on your ESP32'**
  String get qrScannerInstructionTitle;

  /// No description provided for @qrScannerInstructionSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Make sure the QR code is clearly visible and well lit'**
  String get qrScannerInstructionSubtitle;

  /// No description provided for @firebaseInitErrorTitle.
  ///
  /// In en, this message translates to:
  /// **'Firebase initialization error'**
  String get firebaseInitErrorTitle;

  /// No description provided for @unknownError.
  ///
  /// In en, this message translates to:
  /// **'Unknown error'**
  String get unknownError;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Try again'**
  String get retry;

  /// No description provided for @initializing.
  ///
  /// In en, this message translates to:
  /// **'Initializing...'**
  String get initializing;

  /// No description provided for @connectionErrorTitle.
  ///
  /// In en, this message translates to:
  /// **'Connection error'**
  String get connectionErrorTitle;

  /// No description provided for @connectingToEsp32.
  ///
  /// In en, this message translates to:
  /// **'Connecting to ESP32...'**
  String get connectingToEsp32;

  /// No description provided for @rescanQrCode.
  ///
  /// In en, this message translates to:
  /// **'Rescan QR Code'**
  String get rescanQrCode;

  /// No description provided for @noEsp32Configured.
  ///
  /// In en, this message translates to:
  /// **'No ESP32 configured'**
  String get noEsp32Configured;

  /// No description provided for @configureEsp32.
  ///
  /// In en, this message translates to:
  /// **'Configure ESP32'**
  String get configureEsp32;

  /// No description provided for @setFanTo.
  ///
  /// In en, this message translates to:
  /// **'Set fan to:'**
  String get setFanTo;

  /// No description provided for @fanSpeedLabel.
  ///
  /// In en, this message translates to:
  /// **'Fan speed'**
  String get fanSpeedLabel;

  /// No description provided for @fanSpeedStopped.
  ///
  /// In en, this message translates to:
  /// **'Stopped'**
  String get fanSpeedStopped;

  /// No description provided for @fanSpeedSlow.
  ///
  /// In en, this message translates to:
  /// **'Slow'**
  String get fanSpeedSlow;

  /// No description provided for @fanSpeedMedium.
  ///
  /// In en, this message translates to:
  /// **'Medium'**
  String get fanSpeedMedium;

  /// No description provided for @fanSpeedFast.
  ///
  /// In en, this message translates to:
  /// **'Fast'**
  String get fanSpeedFast;

  /// No description provided for @fanModeAuto.
  ///
  /// In en, this message translates to:
  /// **'Automatic'**
  String get fanModeAuto;

  /// No description provided for @fanModeManual.
  ///
  /// In en, this message translates to:
  /// **'Manual'**
  String get fanModeManual;

  /// No description provided for @fanManualModeLabel.
  ///
  /// In en, this message translates to:
  /// **'Fan manual mode'**
  String get fanManualModeLabel;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @fanSpeedSetTo.
  ///
  /// In en, this message translates to:
  /// **'Fan speed set to {speed}'**
  String fanSpeedSetTo(String speed);

  /// No description provided for @thresholdsConstraint.
  ///
  /// In en, this message translates to:
  /// **'Thresholds must satisfy: Slow < Medium < Fast'**
  String get thresholdsConstraint;

  /// No description provided for @thresholdsUpdated.
  ///
  /// In en, this message translates to:
  /// **'Thresholds updated successfully'**
  String get thresholdsUpdated;

  /// No description provided for @degreesCelsius.
  ///
  /// In en, this message translates to:
  /// **'Degrees Celsius'**
  String get degreesCelsius;

  /// No description provided for @fahrenheit.
  ///
  /// In en, this message translates to:
  /// **'Fahrenheit'**
  String get fahrenheit;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['en', 'fr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en': return AppLocalizationsEn();
    case 'fr': return AppLocalizationsFr();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
