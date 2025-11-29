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
}
