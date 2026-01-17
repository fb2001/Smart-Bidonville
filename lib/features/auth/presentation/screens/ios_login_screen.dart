import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../core/services/auth_service.dart';
import '../../../../shared/theme/ios_theme.dart';
import '../../../../shared/widgets/ios_card.dart';
import 'signup_screen.dart';
import '../../../dashboard/view/dashboard_screen.dart';

/// iOS-style login screen following Apple HIG
class IOSLoginScreen extends StatefulWidget {
  const IOSLoginScreen({super.key});

  @override
  State<IOSLoginScreen> createState() => _IOSLoginScreenState();
}

class _IOSLoginScreenState extends State<IOSLoginScreen> {
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
    HapticFeedback.selectionClick();
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
      _showErrorSnackBar('${tr.errorOccurred}: $error');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;

    HapticFeedback.selectionClick();
    setState(() => _isLoading = true);

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
        _showErrorSnackBar(_getErrorMessage(errorCode.toString(), tr));
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: IOSTheme.dangerColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(IOSTheme.radiusMedium),
        ),
        margin: const EdgeInsets.all(IOSTheme.spacing16),
      ),
    );
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

  Future<void> _showForgotPasswordDialog() async {
    final tr = AppLocalizations.of(context)!;
    final emailController = TextEditingController();

    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(IOSTheme.radiusLarge),
        ),
        title: Text(tr.resetPassword),
        content: TextField(
          controller: emailController,
          decoration: InputDecoration(
            labelText: tr.email,
            hintText: tr.enterYourEmail,
          ),
          keyboardType: TextInputType.emailAddress,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(tr.cancel),
          ),
          TextButton(
            onPressed: () async {
              try {
                await _authService.resetPassword(emailController.text);
                if (mounted) {
                  Navigator.pop(context);
                  _showSuccessSnackBar(tr.resetEmailSent);
                }
              } catch (errorCode) {
                if (mounted) {
                  final tr = AppLocalizations.of(context)!;
                  _showErrorSnackBar(_getErrorMessage(errorCode.toString(), tr));
                }
              }
            },
            child: Text(tr.send),
          ),
        ],
      ),
    );
  }

  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: IOSTheme.accentColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(IOSTheme.radiusMedium),
        ),
        margin: const EdgeInsets.all(IOSTheme.spacing16),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final tr = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: IOSTheme.spacing24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 60),

                // Logo
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary,
                    borderRadius: BorderRadius.circular(IOSTheme.radiusXLarge),
                    boxShadow: [
                      BoxShadow(
                        color: Theme.of(context)
                            .colorScheme
                            .primary
                            .withValues(alpha: 0.3),
                        blurRadius: 20,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.home_rounded,
                    size: 50,
                    color: Colors.white,
                  ),
                ),

                const SizedBox(height: IOSTheme.spacing24),

                // Title
                Text(
                  'Smart Home',
                  style: Theme.of(context).textTheme.displayLarge,
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: IOSTheme.spacing8),

                Text(
                  tr.manageYourDevice,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context)
                            .colorScheme
                            .onSurface
                            .withValues(alpha: 0.6),
                      ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 48),

                // Google Sign In Button (Primary action)
                IOSButton(
                  text: 'Continue with Google',
                  onPressed: _isLoading ? null : _handleGoogleLogin,
                  icon: Icons.g_mobiledata_rounded,
                  isPrimary: true,
                ),

                const SizedBox(height: IOSTheme.spacing24),

                // Divider with "or"
                Row(
                  children: [
                    Expanded(
                      child: Divider(
                        color: Theme.of(context).dividerColor,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: IOSTheme.spacing16,
                      ),
                      child: Text(
                        'or',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSurface
                                  .withValues(alpha: 0.5),
                            ),
                      ),
                    ),
                    Expanded(
                      child: Divider(
                        color: Theme.of(context).dividerColor,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: IOSTheme.spacing24),

                // Email Field
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                    labelText: tr.email,
                    hintText: tr.enterYourEmail,
                    prefixIcon: const Icon(Icons.email_outlined),
                  ),
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

                const SizedBox(height: IOSTheme.spacing16),

                // Password Field
                TextFormField(
                  controller: _passwordController,
                  obscureText: _obscurePassword,
                  textInputAction: TextInputAction.done,
                  onFieldSubmitted: (_) => _handleLogin(),
                  decoration: InputDecoration(
                    labelText: tr.password,
                    hintText: '••••••••',
                    prefixIcon: const Icon(Icons.lock_outline),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                      ),
                      onPressed: () {
                        setState(() => _obscurePassword = !_obscurePassword);
                      },
                    ),
                  ),
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

                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: _showForgotPasswordDialog,
                    child: Text(
                      tr.forgotPassword,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Theme.of(context).colorScheme.primary,
                          ),
                    ),
                  ),
                ),

                const SizedBox(height: IOSTheme.spacing16),

                // Login Button
                IOSButton(
                  text: _isLoading ? 'Signing in...' : tr.login,
                  onPressed: _isLoading ? null : _handleLogin,
                  icon: Icons.arrow_forward_rounded,
                  isPrimary: true,
                ),

                const SizedBox(height: IOSTheme.spacing32),

                // Sign Up Link
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      tr.noAccount,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Theme.of(context)
                                .colorScheme
                                .onSurface
                                .withValues(alpha: 0.6),
                          ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => const SignUpScreen(),
                          ),
                        );
                      },
                      child: Text(
                        tr.signup,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Theme.of(context).colorScheme.primary,
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: IOSTheme.spacing24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
