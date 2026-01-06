import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../shared/widgets/ip_config_dialog.dart';
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

    // Show IP config dialog if not configured
    if (!mounted) return;

    final config = Esp32Config();
    final isConfigured = await config.isConfigured();
    if (!isConfigured && mounted) {
      final ip = await showIpConfigDialog(context);
      if (ip != null) {
        await provider.setIpAddress(ip);
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
    final newIp = await showIpConfigDialog(context, currentIp: currentIp);

    if (newIp != null && mounted) {
      await context.read<DashboardProvider>().setIpAddress(newIp);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Smart Bidonville'),
        actions: [
          Consumer<DashboardProvider>(
            builder: (context, provider, _) {
              return Row(
                children: [
                  if (provider.state.isPolling)
                    const Padding(
                      padding: EdgeInsets.only(right: 12.0),
                      child: SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
                        ),
                      ),
                    ),
                  IconButton(
                    icon: const Icon(Icons.settings_ethernet),
                    onPressed: _handleIpReconfigure,
                    tooltip: 'Configure ESP32 IP',
                  ),
                  IconButton(
                    icon: const Icon(Icons.refresh),
                    onPressed: () => provider.refreshData(),
                    tooltip: 'Refresh',
                  ),
                  IconButton(
                    icon: const Icon(Icons.logout),
                    onPressed: _handleSignOut,
                    tooltip: 'Logout',
                  ),
                ],
              );
            },
          ),
        ],
      ),
      body: Consumer<DashboardProvider>(
        builder: (context, provider, _) {
          final state = provider.state;

          // Error state
          if (state.hasError && state.errorMessage != null) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      color: Colors.red,
                      size: 64,
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Connection Error',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      state.errorMessage!,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade400,
                      ),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton.icon(
                      onPressed: () => provider.refreshData(),
                      icon: const Icon(Icons.refresh),
                      label: const Text('Retry'),
                    ),
                    const SizedBox(height: 12),
                    TextButton(
                      onPressed: _handleIpReconfigure,
                      child: const Text('Change IP Address'),
                    ),
                  ],
                ),
              ),
            );
          }

          // Loading state
          if (state.isLoading && !state.hasData) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Connecting to ESP32...'),
                ],
              ),
            );
          }

          // Data loaded
          if (state.hasData) {
            final fanStatus = state.fanStatus!;

            return RefreshIndicator(
              onRefresh: () => provider.refreshData(),
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    // Temperature display
                    TemperatureCard(temperature: fanStatus.temperature),
                    const SizedBox(height: 16),

                    // Fan status indicator
                    FanStatusIndicator(fanStatus: fanStatus),
                    const SizedBox(height: 16),

                    // Mode switch
                    const ModeSwitchCard(),
                    const SizedBox(height: 16),

                    // Manual control (disabled in AUTO mode)
                    const ManualControlCard(),
                    const SizedBox(height: 16),

                    // Auto threshold configuration (disabled in MANUAL mode)
                    const AutoThresholdCard(),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            );
          }

          // Initial state
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.router,
                  size: 64,
                  color: Colors.grey,
                ),
                const SizedBox(height: 16),
                const Text(
                  'No ESP32 configured',
                  style: TextStyle(fontSize: 18),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: _handleIpReconfigure,
                  child: const Text('Configure ESP32'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
