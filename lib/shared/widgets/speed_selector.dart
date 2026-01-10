import 'package:flutter/material.dart';
import '../../core/models/fan_speed.dart';
import '../theme/app_theme.dart';

/// Speed selector widget matching Figma design
/// Shows Slow/Medium/Fast options with icons from assets
class SpeedSelector extends StatelessWidget {
  final FanSpeed? selectedSpeed;
  final ValueChanged<FanSpeed> onSpeedSelected;
  final bool enabled;

  const SpeedSelector({
    super.key,
    required this.selectedSpeed,
    required this.onSpeedSelected,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: FanSpeed.values.map((speed) {
        final isSelected = speed == selectedSpeed;
        return Padding(
          padding: const EdgeInsets.only(bottom: AppSpacing.sm),
          child: _SpeedOptionTile(
            speed: speed,
            isSelected: isSelected,
            enabled: enabled,
            onTap: () => onSpeedSelected(speed),
          ),
        );
      }).toList(),
    );
  }
}

class _SpeedOptionTile extends StatelessWidget {
  final FanSpeed speed;
  final bool isSelected;
  final bool enabled;
  final VoidCallback onTap;

  const _SpeedOptionTile({
    required this.speed,
    required this.isSelected,
    required this.enabled,
    required this.onTap,
  });

  String get _iconAsset {
    switch (speed) {
      case FanSpeed.slow:
        return 'assets/icons8-escargot-50.png';
      case FanSpeed.medium:
        return 'assets/icons8-vitesse-50.png';
      case FanSpeed.fast:
        return 'assets/icons8-vitesse-maximum-50.png';
    }
  }

  Color get _speedColor {
    switch (speed) {
      case FanSpeed.slow:
        return AppColors.speedSlow;
      case FanSpeed.medium:
        return AppColors.speedMedium;
      case FanSpeed.fast:
        return AppColors.speedFast;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: enabled ? 1.0 : 0.5,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: enabled ? onTap : null,
          borderRadius: AppRadius.borderRadiusMd,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.sm,
            ),
            decoration: BoxDecoration(
              color: isSelected
                  ? AppColors.glassSurface
                  : Colors.transparent,
              borderRadius: AppRadius.borderRadiusMd,
              border: Border.all(
                color: isSelected ? _speedColor : AppColors.glassBorder,
                width: isSelected ? 2 : 1,
              ),
            ),
            child: Row(
              children: [
                // Speed icon from assets
                Container(
                  width: 40,
                  height: 40,
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: _speedColor.withOpacity(0.2),
                    borderRadius: AppRadius.borderRadiusSm,
                  ),
                  child: Image.asset(
                    _iconAsset,
                    color: _speedColor,
                    errorBuilder: (context, error, stackTrace) {
                      return Icon(
                        _getFallbackIcon(),
                        color: _speedColor,
                        size: 24,
                      );
                    },
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                // Speed label
                Expanded(
                  child: Text(
                    speed.displayName,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                      color: isSelected
                          ? AppColors.textPrimary
                          : AppColors.textSecondary,
                    ),
                  ),
                ),
                // Selection indicator
                if (isSelected)
                  Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      color: _speedColor,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.check,
                      color: Colors.white,
                      size: 16,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  IconData _getFallbackIcon() {
    switch (speed) {
      case FanSpeed.slow:
        return Icons.speed;
      case FanSpeed.medium:
        return Icons.speed;
      case FanSpeed.fast:
        return Icons.speed;
    }
  }
}

/// Compact speed selector for dashboard status display
class SpeedIndicatorChip extends StatelessWidget {
  final FanSpeed speed;

  const SpeedIndicatorChip({super.key, required this.speed});

  Color get _speedColor {
    switch (speed) {
      case FanSpeed.slow:
        return AppColors.speedSlow;
      case FanSpeed.medium:
        return AppColors.speedMedium;
      case FanSpeed.fast:
        return AppColors.speedFast;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: _speedColor.withOpacity(0.2),
        borderRadius: AppRadius.borderRadiusSm,
        border: Border.all(color: _speedColor, width: 1),
      ),
      child: Text(
        speed.displayName,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: _speedColor,
        ),
      ),
    );
  }
}
