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
        _errorMessage = 'Veuillez entrer une adresse IP';
      });
      return;
    }

    if (!_validateIp(ip)) {
      setState(() {
        _errorMessage = 'Format IP invalide (ex: 192.168.1.100)';
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
          _errorMessage = 'Échec du scan QR : ${e.toString()}';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Dialog(
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
                  'Configuration ESP32',
                  style: AppTypography.titleLarge,
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.lg),

            Text(
              'Connectez-vous à votre TTGO T-Display ESP32 :',
              style: AppTypography.bodyMedium,
            ),
            const SizedBox(height: AppSpacing.lg),

            // Bouton scan QR
            SecondaryButton(
              text: 'Scanner le QR Code',
              icon: Icons.qr_code_scanner,
              onPressed: _handleQrScan,
            ),

            const SizedBox(height: AppSpacing.md),

            // Séparateur avec "OU"
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
                    'OU',
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

            // Saisie manuelle de l'IP
            Text(
              'Entrer l\'adresse IP manuellement :',
              style: AppTypography.labelMedium,
            ),
            const SizedBox(height: AppSpacing.sm),

            AppTextField(
              controller: _controller,
              labelText: 'Adresse IP',
              hintText: '192.168.1.100',
              keyboardType: TextInputType.number,
              textInputAction: TextInputAction.done,
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

            const SizedBox(height: AppSpacing.lg),

            // Actions
            Row(
              children: [
                Expanded(
                  child: SecondaryButton(
                    text: 'Annuler',
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: PrimaryButton(
                    text: 'Connecter',
                    onPressed: _handleSubmit,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      ),
    );
  }
}

Future<DeviceCredentials?> showIpConfigDialog(BuildContext context, {String? currentIp}) {
  return showDialog<DeviceCredentials>(
    context: context,
    barrierDismissible: false,
    barrierColor: Colors.black.withOpacity(0.85),
    builder: (context) => IpConfigDialog(currentIp: currentIp),
  );
}
