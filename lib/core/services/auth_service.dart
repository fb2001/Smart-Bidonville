import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Obtenir l'utilisateur actuel
  User? get currentUser => _auth.currentUser;

  // Stream pour écouter les changements d'authentification
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Connexion avec email et mot de passe
  Future<UserCredential?> signInWithEmailPassword(
      String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw e.code; // Retourner juste le code d'erreur
    }
  }

  // Inscription avec email et mot de passe
  Future<UserCredential?> signUpWithEmailPassword(
      String email, String password) async {
    try {
      UserCredential userCredential =
      await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw e.code; // Retourner juste le code d'erreur
    }
  }

  // Déconnexion
  Future<void> signOut() async {
    await GoogleSignIn().signOut();
    await _auth.signOut();
  }

  // Réinitialisation du mot de passe
  Future<void> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email.trim());
    } on FirebaseAuthException catch (e) {
      throw e.code; // Retourner juste le code d'erreur
    }
  }

  Future<UserCredential?> signInWithGoogle() async {
    try {
      // Ouvre le sélecteur de compte Google
      final googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) {
        // L’utilisateur a annulé
        return null;
      }

      final googleAuth = await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      return await _auth.signInWithCredential(credential);
    } on FirebaseAuthException catch (e) {
      throw e.code;
    } catch (e) {
      // Erreur non Firebase (ex: config Android, etc.)
      throw e.toString();
    }
  }



}