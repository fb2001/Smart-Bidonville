import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../shared/theme/app_theme.dart';
import '../../../shared/widgets/ip_config_dialog.dart';
import '../../../shared/widgets/glass_card.dart';
import '../../../shared/widgets/app_button.dart';
import '../../../core/config/esp32_config.dart';
import '../viewmodel/dashboard_provider.dart';
import '../widgets/temperature_card.dart';
import '../widgets/mode_switch_card.dart';
import '../widgets/manual_control_card.dart';
import '../widgets/auto_threshold_card.dart';
import '../widgets/fan_status_indicator.dart';
import '../../../core/services/auth_service.dart';
import '../../auth/presentation/screens/login_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeDashboard();
    });
  }

  Future<void> _initializeDashboard() async {
    final provider = context.read<DashboardProvider>();
    await provider.initialize();

    if (!mounted) return;

    final config = Esp32Config();
    final isConfigured = await config.isConfigured();
    if (!isConfigured && mounted) {
      final credentials = await showIpConfigDialog(context);
      if (credentials != null) {
        await provider.setCredentials(credentials);
      }
    }
  }

  Future<void> _handleSignOut() async {
    final authService = AuthService();
    await authService.signOut();

    if (mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const LoginScreen()),
      );
    }
  }

  Future<void> _handleIpReconfigure() async {
    final currentIp = await Esp32Config().getIpAddress();
    final newCredentials = await showIpConfigDialog(context, currentIp: currentIp);

    if (newCredentials != null && mounted) {
      await context.read<DashboardProvider>().setCredentials(newCredentials);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/background_dashboard.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Consumer<DashboardProvider>(
            builder: (context, provider, _) {
              final state = provider.state;

              return Column(
                children: [
                  // Top App Bar
                  _buildAppBar(provider),

                  // Content
                  Expanded(
                    child: _buildContent(provider, state),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar(DashboardProvider provider) {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Row(
        children: [
          // Connection status indicator
          if (provider.state.isPolling)
            Container(
              width: 8,
              height: 8,
              decoration: const BoxDecoration(
                color: AppColors.success,
                shape: BoxShape.circle,
              ),
            ),
          const Spacer(),
          // Bouton de configuration
          GlassIconButton(
            assetPath: 'assets/icons8-mode-portrait-50.png',
            onPressed: _handleIpReconfigure,
            size: 40,
          ),
          const SizedBox(width: AppSpacing.sm),
          // Bouton de déconnexion
          GlassIconButton(
            assetPath: 'assets/icons8-sortie-50.png',
            onPressed: _handleSignOut,
            size: 40,
          ),
        ],
      ),
    );
  }

  Widget _buildContent(DashboardProvider provider, state) {
    // Error state
    if (state.hasError && state.errorMessage != null) {
      return _buildErrorState(provider, state.errorMessage!);
    }

    // Loading state
    if (state.isLoading && !state.hasData) {
      return _buildLoadingState();
    }

    // Data loaded
    if (state.hasData) {
      return _buildDataState(provider, state);
    }

    // Initial state
    return _buildInitialState();
  }

  Widget _buildErrorState(DashboardProvider provider, String errorMessage) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: SimpleGlassCard(
          padding: const EdgeInsets.all(AppSpacing.xl),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.error_outline,
                color: AppColors.error,
                size: 64,
              ),
              const SizedBox(height: AppSpacing.md),
              Text(
                'Erreur de connexion',
                style: AppTypography.titleLarge,
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                errorMessage,
                textAlign: TextAlign.center,
                style: AppTypography.bodyMedium,
              ),
              const SizedBox(height: AppSpacing.lg),
              PrimaryButton(
                text: 'Réessayer',
                onPressed: () => provider.refreshData(),
              ),
              const SizedBox(height: AppSpacing.sm),
              SecondaryButton(
                text: 'Rescanner QR Code',
                onPressed: _handleIpReconfigure,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: SimpleGlassCard(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(
              width: 48,
              height: 48,
              child: CircularProgressIndicator(
                color: AppColors.primary,
                strokeWidth: 3,
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              'Connexion à l\'ESP32...',
              style: AppTypography.bodyLarge,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDataState(DashboardProvider provider, state) {
    final fanStatus = state.fanStatus!;

    return RefreshIndicator(
      onRefresh: () => provider.refreshData(),
      color: AppColors.primary,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Temperature display
            TemperatureCard(temperature: fanStatus.temperature),
            const SizedBox(height: AppSpacing.md),

            // Fan status with mode
            FanStatusIndicator(fanStatus: fanStatus),
            const SizedBox(height: AppSpacing.lg),

            // Titre de section "Régler le ventilateur sur :"
            Text(
              'Régler le ventilateur sur :',
              style: AppTypography.titleLarge.copyWith(
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: AppSpacing.md),

            // Mode switch
            const ModeSwitchCard(),
            const SizedBox(height: AppSpacing.md),

            // Conditional controls based on mode
            if (fanStatus.mode.isManual)
              const ManualControlCard()
            else
              const AutoThresholdCard(),

            const SizedBox(height: AppSpacing.xxl),
          ],
        ),
      ),
    );
  }

  Widget _buildInitialState() {
    return Center(
      child: SimpleGlassCard(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.router,
              size: 64,
              color: AppColors.textMuted,
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              'Aucun ESP32 configuré',
              style: AppTypography.titleLarge,
            ),
            const SizedBox(height: AppSpacing.lg),
            PrimaryButton(
              text: 'Configurer ESP32',
              onPressed: _handleIpReconfigure,
              width: 180,
            ),
          ],
        ),
      ),
    );
  }
}
