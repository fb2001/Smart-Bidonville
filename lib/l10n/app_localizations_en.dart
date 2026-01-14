// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get login => 'Log In';

  @override
  String get signup => 'Create an account';

  @override
  String get email => 'Email';

  @override
  String get password => 'Password';

  @override
  String get confirmPassword => 'Confirm Password';

  @override
  String get signInto => 'Sign Into';

  @override
  String get manageYourDevice => 'Manage Your Device & Accessory';

  @override
  String get noAccount => 'Don\'t have an account yet?';

  @override
  String get alreadyHaveAccount => 'Already have an account?';

  @override
  String get loggingIn => 'Logging in...';

  @override
  String get creatingAccount => 'Creating account...';

  @override
  String get forgotPassword => 'Forgot password?';

  @override
  String get resetPassword => 'Reset Password';

  @override
  String get sendResetEmail => 'Send Reset Email';

  @override
  String get cancel => 'Cancel';

  @override
  String get close => 'Close';

  @override
  String get send => 'Send';

  @override
  String get enterYourEmail => 'Enter your email';

  @override
  String get resetEmailSent => 'Reset email sent';

  @override
  String get logout => 'Log Out';

  @override
  String get welcome => 'Welcome!';

  @override
  String get connectedAs => 'Connected as:';

  @override
  String get createNewAccount => 'Create a new account';

  @override
  String get emailRequired => 'Email is required';

  @override
  String get invalidEmail => 'Invalid email';

  @override
  String get passwordRequired => 'Password is required';

  @override
  String get passwordTooShort => 'Password must be at least 6 characters';

  @override
  String get confirmPasswordRequired => 'Password confirmation is required';

  @override
  String get passwordsDoNotMatch => 'Passwords do not match';

  @override
  String get userNotFound => 'No user found with this email.';

  @override
  String get wrongPassword => 'Incorrect password.';

  @override
  String get emailAlreadyInUse => 'An account already exists with this email.';

  @override
  String get weakPassword => 'Password must contain at least 6 characters.';

  @override
  String get userDisabled => 'This account has been disabled.';

  @override
  String get tooManyRequests => 'Too many attempts. Try again later.';

  @override
  String get operationNotAllowed => 'Operation not allowed.';

  @override
  String get errorOccurred => 'An error occurred';

  @override
  String get esp32ConfigurationTitle => 'ESP32 Configuration';

  @override
  String get esp32ConnectInstruction => 'Connect to your TTGO T-Display ESP32:';

  @override
  String get scanQrCode => 'Scan QR Code';

  @override
  String qrScanFailed(String error) {
    return 'QR scan failed: $error';
  }

  @override
  String get qrScannerTitle => 'Scan ESP32 QR Code';

  @override
  String qrInvalid(String error) {
    return 'Invalid QR code: $error';
  }

  @override
  String get toggleFlashlight => 'Toggle flashlight';

  @override
  String get switchCamera => 'Switch camera';

  @override
  String get qrScannerInstructionTitle => 'Scan the QR code shown on your ESP32';

  @override
  String get qrScannerInstructionSubtitle => 'Make sure the QR code is clearly visible and well lit';

  @override
  String get firebaseInitErrorTitle => 'Firebase initialization error';

  @override
  String get unknownError => 'Unknown error';

  @override
  String get retry => 'Try again';

  @override
  String get initializing => 'Initializing...';

  @override
  String get connectionErrorTitle => 'Connection error';

  @override
  String get connectingToEsp32 => 'Connecting to ESP32...';

  @override
  String get rescanQrCode => 'Rescan QR Code';

  @override
  String get noEsp32Configured => 'No ESP32 configured';

  @override
  String get configureEsp32 => 'Configure ESP32';

  @override
  String get setFanTo => 'Set fan to:';

  @override
  String get fanSpeedLabel => 'Fan speed';

  @override
  String get fanSpeedStopped => 'Stopped';

  @override
  String get fanSpeedSlow => 'Slow';

  @override
  String get fanSpeedMedium => 'Medium';

  @override
  String get fanSpeedFast => 'Fast';

  @override
  String get fanModeAuto => 'Automatic';

  @override
  String get fanModeManual => 'Manual';

  @override
  String get fanManualModeLabel => 'Fan manual mode';

  @override
  String get save => 'Save';

  @override
  String fanSpeedSetTo(String speed) {
    return 'Fan speed set to $speed';
  }

  @override
  String get thresholdsConstraint => 'Thresholds must satisfy: Slow < Medium < Fast';

  @override
  String get thresholdsUpdated => 'Thresholds updated successfully';

  @override
  String get degreesCelsius => 'Degrees Celsius';

  @override
  String get fahrenheit => 'Fahrenheit';
}
