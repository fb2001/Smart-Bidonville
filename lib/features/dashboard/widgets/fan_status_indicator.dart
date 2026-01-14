import 'package:flutter/material.dart';
import '../../../core/models/fan_status.dart';
import '../../../l10n/app_localizations.dart';
import '../../../shared/localization/fan_localizations.dart';
import '../../../shared/theme/app_theme.dart';
import '../../../shared/widgets/glass_card.dart';

/// Indicateur d'état du ventilateur selon le design Figma
/// Affiche le mode actuel et la vitesse du ventilateur
class FanStatusIndicator extends StatelessWidget {
  final FanStatus fanStatus;

  const FanStatusIndicator({Key? key, required this.fanStatus}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return SimpleGlassCard(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // Mode display
          _StatusItem(
            value: fanStatus.mode.localizedName(l10n),
            label: '',
            valueColor: AppColors.textPrimary,
          ),
          // Divider
          Container(
            height: 60,
            width: 1,
            color: AppColors.glassBorder,
          ),
          // Affichage de la vitesse
          _StatusItem(
            value: fanStatus.speed?.localizedName(l10n) ?? l10n.fanSpeedStopped,
            label: l10n.fanSpeedLabel,
            valueColor: _getSpeedColor(),
          ),
        ],
      ),
    );
  }

  Color _getSpeedColor() {
    if (fanStatus.speed == null) return AppColors.textMuted;

    switch (fanStatus.speed!.name) {
      case 'slow':
        return AppColors.speedSlow;
      case 'medium':
        return AppColors.speedMedium;
      case 'fast':
        return AppColors.speedFast;
      default:
        return AppColors.textPrimary;
    }
  }
}

class _StatusItem extends StatelessWidget {
  final String value;
  final String label;
  final Color valueColor;

  const _StatusItem({
    required this.value,
    required this.label,
    required this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w700,
            color: valueColor,
          ),
        ),
        if (label.isNotEmpty) ...[
          const SizedBox(height: AppSpacing.xs),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              color: AppColors.textMuted,
            ),
          ),
        ],
      ],
    );
  }
}
