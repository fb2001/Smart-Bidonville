import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'features/auth/presentation/screens/login_screen.dart';
import 'features/dashboard/view/dashboard_screen.dart';
import 'core/services/auth_service.dart';
import 'features/dashboard/viewmodel/dashboard_provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'l10n/app_localizations.dart';
import 'shared/theme/app_theme.dart';

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
        title: 'Smart Home',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.darkTheme,
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('fr'),
          Locale('en'),
        ],
        locale: const Locale('fr'),
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
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
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
      debugPrint('Firebase Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    // Error state
    if (_error) {
      return Scaffold(
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                const Color(0xFF3D3520),
                AppColors.backgroundDark,
              ],
            ),
          ),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.error_outline,
                    color: AppColors.error,
                    size: 80,
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  Text(
                    'Erreur d\'initialisation Firebase',
                    style: AppTypography.titleLarge,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Text(
                    _errorMessage ?? 'Erreur inconnue',
                    style: AppTypography.bodyMedium,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: AppSpacing.xl),
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

    // Loading state - Splash screen
    if (!_initialized) {
      return Scaffold(
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                const Color(0xFF3D3520),
                AppColors.backgroundDark,
              ],
            ),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'SMART',
                  style: AppTypography.displaySmall.copyWith(
                    letterSpacing: 8,
                  ),
                ),
                Text(
                  'HOME',
                  style: AppTypography.displayLarge.copyWith(
                    letterSpacing: 6,
                  ),
                ),
                const SizedBox(height: AppSpacing.xxl),
                const SizedBox(
                  width: 32,
                  height: 32,
                  child: CircularProgressIndicator(
                    color: AppColors.primary,
                    strokeWidth: 3,
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                Text(
                  'Initialisation...',
                  style: AppTypography.bodyMedium,
                ),
              ],
            ),
          ),
        ),
      );
    }

    // Check auth state
    return const AuthStateHandler();
  }
}

class AuthStateHandler extends StatelessWidget {
  const AuthStateHandler({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authService = AuthService();

    if (authService.currentUser != null) {
      return const DashboardScreen();
    } else {
      return const LoginScreen();
    }
  }
}
