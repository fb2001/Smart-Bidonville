import 'package:flutter/material.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../core/services/auth_service.dart';
import '../../../../shared/theme/app_theme.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/app_text_field.dart';
import '../../../../shared/widgets/glass_card.dart';
import 'signup_screen.dart';
import '../../../dashboard/view/dashboard_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _authService = AuthService();

  bool _obscurePassword = true;
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleGoogleLogin() async {
    setState(() => _isLoading = true);

    try {
      final credential = await _authService.signInWithGoogle();

      if (credential == null) return;

      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const DashboardScreen()),
        );
      }
    } catch (error) {
      if (!mounted) return;
      final tr = AppLocalizations.of(context)!;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${tr.errorOccurred}: $error'),
          backgroundColor: AppColors.error,
          duration: const Duration(seconds: 4),
        ),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  String _getErrorMessage(String errorCode, AppLocalizations tr) {
    switch (errorCode) {
      case 'user-not-found':
        return tr.userNotFound;
      case 'wrong-password':
        return tr.wrongPassword;
      case 'invalid-email':
        return tr.invalidEmail;
      case 'user-disabled':
        return tr.userDisabled;
      case 'too-many-requests':
        return tr.tooManyRequests;
      default:
        return '${tr.errorOccurred}: $errorCode';
    }
  }

  Future<void> _handleLogin() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        await _authService.signInWithEmailPassword(
          _emailController.text,
          _passwordController.text,
        );

        if (mounted) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (_) => const DashboardScreen()),
          );
        }
      } catch (errorCode) {
        if (mounted) {
          final tr = AppLocalizations.of(context)!;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(_getErrorMessage(errorCode.toString(), tr)),
              backgroundColor: AppColors.error,
              duration: const Duration(seconds: 4),
            ),
          );
        }
      } finally {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }
    }
  }

  void _navigateToSignUp() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const SignUpScreen()),
    );
  }

  Future<void> _showForgotPasswordDialog() async {
    final tr = AppLocalizations.of(context)!;
    final emailController = TextEditingController();

    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surfaceDark,
        shape: RoundedRectangleBorder(
          borderRadius: AppRadius.borderRadiusLg,
        ),
        title: Text(
          tr.resetPassword,
          style: AppTypography.titleLarge,
        ),
        content: AppTextField(
          controller: emailController,
          labelText: tr.email,
          hintText: tr.enterYourEmail,
          keyboardType: TextInputType.emailAddress,
          suffixIcon: Icons.email_outlined,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              tr.cancel,
              style: const TextStyle(color: AppColors.textSecondary),
            ),
          ),
          TextButton(
            onPressed: () async {
              try {
                await _authService.resetPassword(emailController.text);
                if (mounted) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(tr.resetEmailSent),
                      backgroundColor: AppColors.success,
                    ),
                  );
                }
              } catch (errorCode) {
                if (mounted) {
                  final tr = AppLocalizations.of(context)!;
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(_getErrorMessage(errorCode.toString(), tr)),
                      backgroundColor: AppColors.error,
                    ),
                  );
                }
              }
            },
            child: Text(
              tr.send,
              style: const TextStyle(color: AppColors.primary),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final tr = AppLocalizations.of(context)!;
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
        width: size.width,
        height: size.height,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/background_login.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Branding section - SMART HOME
              Expanded(
                flex: 4,
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
                    ],
                  ),
                ),
              ),

              // Login form card
              Expanded(
                flex: 6,
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        AppColors.glassSurface,
                        AppColors.backgroundDark.withOpacity(0.9),
                      ],
                    ),
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(AppRadius.xl),
                      topRight: Radius.circular(AppRadius.xl),
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(AppRadius.xl),
                      topRight: Radius.circular(AppRadius.xl),
                    ),
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: Container(
                        constraints: BoxConstraints(
                          minHeight: MediaQuery.of(context).size.height * 0.6,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.lg,
                            vertical: AppSpacing.xl,
                          ),
                          child: Form(
                            key: _formKey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                            // Title
                            Text(
                              tr.signInto,
                              style: AppTypography.titleLarge.copyWith(
                                fontSize: 24,
                              ),
                            ),
                            const SizedBox(height: AppSpacing.xs),
                            Text(
                              tr.manageYourDevice,
                              style: AppTypography.bodyMedium,
                            ),
                            const SizedBox(height: AppSpacing.xl),

                            // Email field
                            AppTextField(
                              controller: _emailController,
                              labelText: tr.email,
                              keyboardType: TextInputType.emailAddress,
                              suffixIcon: Icons.email_outlined,
                              textInputAction: TextInputAction.next,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return tr.emailRequired;
                                }
                                if (!value.contains('@')) {
                                  return tr.invalidEmail;
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: AppSpacing.md),

                            // Password field
                            AppTextField(
                              controller: _passwordController,
                              labelText: tr.password,
                              obscureText: _obscurePassword,
                              suffixIcon: _obscurePassword
                                  ? Icons.lock_outline
                                  : Icons.lock_open_outlined,
                              onSuffixIconTap: () {
                                setState(() {
                                  _obscurePassword = !_obscurePassword;
                                });
                              },
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return tr.passwordRequired;
                                }
                                if (value.length < 6) {
                                  return tr.passwordTooShort;
                                }
                                return null;
                              },
                            ),

                            const SizedBox(height: AppSpacing.lg),

                            // Login button
                            PrimaryButton(
                              text: tr.login,
                              onPressed: _handleLogin,
                              isLoading: _isLoading,
                            ),

                            const SizedBox(height: AppSpacing.lg),

                            // Google login
                            Center(
                              child: SocialButton(
                                assetPath: 'assets/google_logo.png',
                                onPressed: _isLoading ? null : _handleGoogleLogin,
                              ),
                            ),

                            const SizedBox(height: AppSpacing.lg),

                            // Sign up link
                            Center(
                              child: Column(
                                children: [
                                  Text(
                                    tr.noAccount,
                                    style: AppTypography.bodyMedium,
                                  ),
                                  TextButton(
                                    onPressed: _navigateToSignUp,
                                    child: Text(
                                      tr.signup,
                                      style: const TextStyle(
                                        color: AppColors.primary,
                                        fontSize: 14,
                                        decoration: TextDecoration.underline,
                                        decorationColor: AppColors.primary,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
