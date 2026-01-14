// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get login => 'Se connecter';

  @override
  String get signup => 'Créer un compte';

  @override
  String get email => 'Email';

  @override
  String get password => 'Mot de passe';

  @override
  String get confirmPassword => 'Confirmer le mot de passe';

  @override
  String get signInto => 'Se connecter à';

  @override
  String get manageYourDevice => 'Gérez vos appareils et accessoires';

  @override
  String get noAccount => 'Vous n\'avez pas encore de compte ?';

  @override
  String get alreadyHaveAccount => 'Déjà un compte ?';

  @override
  String get loggingIn => 'Connexion en cours...';

  @override
  String get creatingAccount => 'Création du compte...';

  @override
  String get forgotPassword => 'Mot de passe oublié ?';

  @override
  String get resetPassword => 'Réinitialiser le mot de passe';

  @override
  String get sendResetEmail => 'Envoyer l\'email de réinitialisation';

  @override
  String get cancel => 'Annuler';

  @override
  String get close => 'Fermer';

  @override
  String get send => 'Envoyer';

  @override
  String get enterYourEmail => 'Entrez votre email';

  @override
  String get resetEmailSent => 'Email de réinitialisation envoyé';

  @override
  String get logout => 'Se déconnecter';

  @override
  String get welcome => 'Bienvenue !';

  @override
  String get connectedAs => 'Connecté en tant que :';

  @override
  String get createNewAccount => 'Créer un nouveau compte';

  @override
  String get emailRequired => 'Email requis';

  @override
  String get invalidEmail => 'Email invalide';

  @override
  String get passwordRequired => 'Mot de passe requis';

  @override
  String get passwordTooShort => 'Le mot de passe doit contenir au moins 6 caractères';

  @override
  String get confirmPasswordRequired => 'Confirmation du mot de passe requise';

  @override
  String get passwordsDoNotMatch => 'Les mots de passe ne correspondent pas';

  @override
  String get userNotFound => 'Aucun utilisateur trouvé avec cet email.';

  @override
  String get wrongPassword => 'Mot de passe incorrect.';

  @override
  String get emailAlreadyInUse => 'Un compte existe déjà avec cet email.';

  @override
  String get weakPassword => 'Le mot de passe doit contenir au moins 6 caractères.';

  @override
  String get userDisabled => 'Ce compte a été désactivé.';

  @override
  String get tooManyRequests => 'Trop de tentatives. Réessayez plus tard.';

  @override
  String get operationNotAllowed => 'Opération non autorisée.';

  @override
  String get errorOccurred => 'Une erreur est survenue';

  @override
  String get esp32ConfigurationTitle => 'Configuration ESP32';

  @override
  String get esp32ConnectInstruction => 'Connectez-vous à votre TTGO T-Display ESP32 :';

  @override
  String get scanQrCode => 'Scanner le QR Code';

  @override
  String qrScanFailed(String error) {
    return 'Échec du scan QR : $error';
  }

  @override
  String get qrScannerTitle => 'Scanner le QR Code ESP32';

  @override
  String qrInvalid(String error) {
    return 'QR code invalide : $error';
  }

  @override
  String get toggleFlashlight => 'Activer/désactiver la lampe';

  @override
  String get switchCamera => 'Changer de caméra';

  @override
  String get qrScannerInstructionTitle => 'Scannez le QR code affiché sur votre ESP32';

  @override
  String get qrScannerInstructionSubtitle => 'Assurez-vous que le QR code est clairement visible et bien éclairé';

  @override
  String get firebaseInitErrorTitle => 'Erreur d\'initialisation Firebase';

  @override
  String get unknownError => 'Erreur inconnue';

  @override
  String get retry => 'Réessayer';

  @override
  String get initializing => 'Initialisation...';

  @override
  String get connectionErrorTitle => 'Erreur de connexion';

  @override
  String get connectingToEsp32 => 'Connexion à l\'ESP32...';

  @override
  String get rescanQrCode => 'Rescanner QR Code';

  @override
  String get noEsp32Configured => 'Aucun ESP32 configuré';

  @override
  String get configureEsp32 => 'Configurer ESP32';

  @override
  String get setFanTo => 'Régler le ventilateur sur :';

  @override
  String get fanSpeedLabel => 'Vitesse du ventilateur';

  @override
  String get fanSpeedStopped => 'Arrêté';

  @override
  String get fanSpeedSlow => 'Lent';

  @override
  String get fanSpeedMedium => 'Moyen';

  @override
  String get fanSpeedFast => 'Rapide';

  @override
  String get fanModeAuto => 'Automatique';

  @override
  String get fanModeManual => 'Manuel';

  @override
  String get fanManualModeLabel => 'Mode manuel du ventilateur';

  @override
  String get save => 'Enregistrer';

  @override
  String fanSpeedSetTo(String speed) {
    return 'Vitesse du ventilateur réglée sur $speed';
  }

  @override
  String get thresholdsConstraint => 'Les seuils doivent respecter : Lent < Moyen < Rapide';

  @override
  String get thresholdsUpdated => 'Seuils mis à jour avec succès';

  @override
  String get degreesCelsius => 'Degrés Celsius';

  @override
  String get fahrenheit => 'Fahrenheit';
}
