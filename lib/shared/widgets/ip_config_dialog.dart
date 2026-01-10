import 'package:flutter/material.dart';
import '../../core/models/device_credentials.dart';
import '../theme/app_theme.dart';
import 'app_button.dart';
import 'app_text_field.dart';
import 'glass_card.dart';
import 'qr_scanner_screen.dart';

class IpConfigDialog extends StatefulWidget {
  final String? currentIp;

  const IpConfigDialog({super.key, this.currentIp});

  @override
  State<IpConfigDialog> createState() => _IpConfigDialogState();
}

class _IpConfigDialogState extends State<IpConfigDialog> {
  late final TextEditingController _controller;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.currentIp ?? '192.168.');
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  bool _validateIp(String ip) {
    final ipRegex = RegExp(
      r'^(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$',
    );
    return ipRegex.hasMatch(ip);
  }

  void _handleSubmit() {
    final ip = _controller.text.trim();

    if (ip.isEmpty) {
      setState(() {
        _errorMessage = 'Please enter an IP address';
      });
      return;
    }

    if (!_validateIp(ip)) {
      setState(() {
        _errorMessage = 'Invalid IP format (e.g., 192.168.1.100)';
      });
      return;
    }

    final credentials = DeviceCredentials(
      ipAddress: ip,
      authToken: '',
    );
    Navigator.of(context).pop(credentials);
  }

  Future<void> _handleQrScan() async {
    try {
      final credentials = await Navigator.of(context).push<DeviceCredentials>(
        MaterialPageRoute(
          builder: (context) => const QrScannerScreen(),
          fullscreenDialog: true,
        ),
      );

      if (credentials != null && mounted) {
        Navigator.of(context).pop(credentials);
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = 'QR scan failed: ${e.toString()}';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: SimpleGlassCard(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header
            Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.2),
                    borderRadius: AppRadius.borderRadiusSm,
                  ),
                  child: const Icon(
                    Icons.router,
                    color: AppColors.primary,
                    size: 24,
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Text(
                  'ESP32 Configuration',
                  style: AppTypography.titleLarge,
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.lg),

            Text(
              'Connect to your TTGO T-Display ESP32:',
              style: AppTypography.bodyMedium,
            ),
            const SizedBox(height: AppSpacing.lg),

            // QR Scan Button
            SecondaryButton(
              text: 'Scan QR Code (Secure)',
              icon: Icons.qr_code_scanner,
              onPressed: _handleQrScan,
            ),

            const SizedBox(height: AppSpacing.md),

            // Divider with "OR"
            Row(
              children: [
                Expanded(
                  child: Container(
                    height: 1,
                    color: AppColors.glassBorder,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                  child: Text(
                    'OR',
                    style: TextStyle(
                      color: AppColors.textMuted,
                      fontSize: 12,
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    height: 1,
                    color: AppColors.glassBorder,
                  ),
                ),
              ],
            ),

            const SizedBox(height: AppSpacing.md),

            // Manual IP Entry
            Text(
              'Enter IP address manually:',
              style: AppTypography.labelMedium,
            ),
            const SizedBox(height: AppSpacing.sm),

            AppTextField(
              controller: _controller,
              labelText: 'IP Address',
              hintText: '192.168.1.100',
              keyboardType: TextInputType.number,
              suffixIcon: Icons.edit,
              onChanged: (_) {
                if (_errorMessage != null) {
                  setState(() {
                    _errorMessage = null;
                  });
                }
              },
            ),

            if (_errorMessage != null) ...[
              const SizedBox(height: AppSpacing.sm),
              Text(
                _errorMessage!,
                style: TextStyle(
                  fontSize: 12,
                  color: AppColors.error,
                ),
              ),
            ],

            const SizedBox(height: AppSpacing.sm),

            // Info text
            Row(
              children: [
                Icon(
                  Icons.info_outline,
                  size: 14,
                  color: AppColors.textMuted,
                ),
                const SizedBox(width: AppSpacing.xs),
                Expanded(
                  child: Text(
                    'Manual entry is less secure - QR code is recommended',
                    style: TextStyle(
                      fontSize: 11,
                      color: AppColors.textMuted,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: AppSpacing.lg),

            // Actions
            Row(
              children: [
                Expanded(
                  child: SecondaryButton(
                    text: 'Cancel',
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: PrimaryButton(
                    text: 'Connect',
                    onPressed: _handleSubmit,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

Future<DeviceCredentials?> showIpConfigDialog(BuildContext context, {String? currentIp}) {
  return showDialog<DeviceCredentials>(
    context: context,
    barrierDismissible: false,
    builder: (context) => IpConfigDialog(currentIp: currentIp),
  );
}
