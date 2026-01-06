import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'features/auth/presentation/screens/ios_login_screen.dart';
import 'features/dashboard/view/dashboard_screen.dart';
import 'features/splash/splash_screen.dart';
import 'core/services/auth_service.dart';
import 'features/dashboard/viewmodel/dashboard_provider.dart';
import 'shared/theme/ios_theme.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'l10n/app_localizations.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => DashboardProvider(),
        ),
      ],
      child: MaterialApp(
        title: 'Smart Bidonville',
        debugShowCheckedModeBanner: false,
        theme: IOSTheme.lightTheme,
        darkTheme: IOSTheme.darkTheme,
        themeMode: ThemeMode.system,
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('en'),
          Locale('fr'),
        ],
        home: const FirebaseInitializer(),
      ),
    );
  }
}

class FirebaseInitializer extends StatefulWidget {
  const FirebaseInitializer({Key? key}) : super(key: key);

  @override
  State<FirebaseInitializer> createState() => _FirebaseInitializerState();
}

class _FirebaseInitializerState extends State<FirebaseInitializer> {
  bool _initialized = false;
  bool _error = false;
  bool _showSplash = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    // Set iOS status bar style
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarBrightness: Brightness.light,
      ),
    );
    _initializeFirebase();
  }

  Future<void> _initializeFirebase() async {
    try {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
      setState(() {
        _initialized = true;
      });
    } catch (e) {
      setState(() {
        _error = true;
        _errorMessage = e.toString();
      });
      debugPrint('Erreur Firebase: $e');
    }
  }

  void _onSplashComplete() {
    setState(() {
      _showSplash = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Show splash screen first
    if (_showSplash && _initialized && !_error) {
      return SplashScreen(onComplete: _onSplashComplete);
    }

    // Afficher un écran d'erreur si Firebase ne peut pas s'initialiser
    if (_error) {
      return Scaffold(
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.grey.shade700,
                Colors.grey.shade900,
              ],
            ),
          ),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.error_outline,
                    color: Colors.red,
                    size: 80,
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Erreur d\'initialisation Firebase',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    _errorMessage ?? 'Erreur inconnue',
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.white70,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 32),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _error = false;
                        _initialized = false;
                      });
                      _initializeFirebase();
                    },
                    child: const Text('Réessayer'),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    // Afficher un écran de chargement pendant l'initialisation
    if (!_initialized) {
      return Scaffold(
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.grey.shade700,
                Colors.grey.shade900,
              ],
            ),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Text(
                  'SMART',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.white70,
                    letterSpacing: 4,
                  ),
                ),
                Text(
                  'BIDONVILLE',
                  style: TextStyle(
                    fontSize: 64,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: 8,
                  ),
                ),
                SizedBox(height: 48),
                CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 3,
                ),
                SizedBox(height: 24),
                Text(
                  'Initialisation...',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    // ✅ CHANGEMENT ICI: Vérifier si l'utilisateur est connecté
    return const AuthStateHandler();
  }
}

// ✅ NOUVEAU WIDGET: Gère l'état d'authentification
class AuthStateHandler extends StatelessWidget {
  const AuthStateHandler({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authService = AuthService();

    // Vérifier si un utilisateur est déjà connecté
    if (authService.currentUser != null) {
      // Utilisateur connecté → Dashboard
      return const DashboardScreen();
    } else {
      // Pas d'utilisateur connecté → Page de connexion
      return const IOSLoginScreen();
    }
  }
}