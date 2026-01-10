import 'package:flutter/material.dart';
import '../../../core/models/fan_status.dart';
import '../../../shared/theme/app_theme.dart';
import '../../../shared/widgets/glass_card.dart';

/// Fan status indicator matching Figma design
/// Shows current mode and speed ventilateur
class FanStatusIndicator extends StatelessWidget {
  final FanStatus fanStatus;

  const FanStatusIndicator({Key? key, required this.fanStatus}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SimpleGlassCard(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // Mode display
          _StatusItem(
            value: fanStatus.mode.displayName,
            label: '',
            valueColor: AppColors.textPrimary,
          ),
          // Divider
          Container(
            height: 60,
            width: 1,
            color: AppColors.glassBorder,
          ),
          // Speed display
          _StatusItem(
            value: fanStatus.speed?.displayName ?? 'Off',
            label: 'Speed ventilateur',
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
