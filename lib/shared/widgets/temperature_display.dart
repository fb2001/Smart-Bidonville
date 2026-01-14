import 'package:flutter/material.dart';
import '../../l10n/app_localizations.dart';
import '../theme/app_theme.dart';
import 'glass_card.dart';

/// Temperature display widget matching Figma design
/// Shows temperature in Celsius and Fahrenheit
class TemperatureDisplay extends StatelessWidget {
  final double temperatureCelsius;

  const TemperatureDisplay({
    super.key,
    required this.temperatureCelsius,
  });

  double get temperatureFahrenheit => (temperatureCelsius * 9 / 5) + 32;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return SimpleGlassCard(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _TemperatureUnit(
            value: temperatureCelsius,
            unit: l10n.degreesCelsius,
            suffix: '°C',
          ),
          Container(
            height: 60,
            width: 1,
            color: AppColors.glassBorder,
          ),
          _TemperatureUnit(
            value: temperatureFahrenheit,
            unit: l10n.fahrenheit,
            suffix: '°F',
          ),
        ],
      ),
    );
  }
}

class _TemperatureUnit extends StatelessWidget {
  final double value;
  final String unit;
  final String suffix;

  const _TemperatureUnit({
    required this.value,
    required this.unit,
    required this.suffix,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: value.toStringAsFixed(0),
                style: const TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              TextSpan(
                text: suffix,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w400,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(
          unit,
          style: const TextStyle(
            fontSize: 12,
            color: AppColors.textMuted,
          ),
        ),
      ],
    );
  }
}

/// Compact temperature chip for status bar
class TemperatureChip extends StatelessWidget {
  final double temperatureCelsius;
  final bool showIcon;

  const TemperatureChip({
    super.key,
    required this.temperatureCelsius,
    this.showIcon = true,
  });

  Color _getTemperatureColor() {
    if (temperatureCelsius < 20) return AppColors.info;
    if (temperatureCelsius < 25) return AppColors.success;
    if (temperatureCelsius < 30) return AppColors.warning;
    return AppColors.error;
  }

  @override
  Widget build(BuildContext context) {
    final color = _getTemperatureColor();

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: AppRadius.borderRadiusSm,
        border: Border.all(color: color, width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (showIcon) ...[
            Icon(
              Icons.thermostat,
              color: color,
              size: 16,
            ),
            const SizedBox(width: AppSpacing.xs),
          ],
          Text(
            '${temperatureCelsius.toStringAsFixed(1)}°C',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
