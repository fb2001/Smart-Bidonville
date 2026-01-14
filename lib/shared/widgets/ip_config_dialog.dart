import 'package:flutter/material.dart';
import '../../core/models/device_credentials.dart';
import '../../l10n/app_localizations.dart';
import '../theme/app_theme.dart';
import 'app_button.dart';
import 'glass_card.dart';
import 'qr_scanner_screen.dart';

class IpConfigDialog extends StatefulWidget {
  const IpConfigDialog({super.key});

  @override
  State<IpConfigDialog> createState() => _IpConfigDialogState();
}

class _IpConfigDialogState extends State<IpConfigDialog> {
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
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
          final l10n = AppLocalizations.of(context)!;
          _errorMessage = l10n.qrScanFailed(e.toString());
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

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
                  l10n.esp32ConfigurationTitle,
                  style: AppTypography.titleLarge,
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.lg),

            Text(
              l10n.esp32ConnectInstruction,
              style: AppTypography.bodyMedium,
            ),
            const SizedBox(height: AppSpacing.lg),

            PrimaryButton(
              text: l10n.scanQrCode,
              icon: Icons.qr_code_scanner,
              onPressed: _handleQrScan,
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
                    text: l10n.close,
                    onPressed: () => Navigator.of(context).pop(),
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

Future<DeviceCredentials?> showIpConfigDialog(BuildContext context) {
  return showDialog<DeviceCredentials>(
    context: context,
    barrierDismissible: false,
    barrierColor: Colors.black.withOpacity(0.85),
    builder: (context) => const IpConfigDialog(),
  );
}
