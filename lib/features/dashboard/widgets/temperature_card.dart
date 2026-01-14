import 'package:flutter/material.dart';
import '../../../l10n/app_localizations.dart';
import '../../../shared/theme/app_theme.dart';
import '../../../shared/widgets/glass_card.dart';

/// Temperature display card matching Figma design
/// Shows temperature in both Celsius and Fahrenheit
class TemperatureCard extends StatelessWidget {
  final double temperature;

  const TemperatureCard({Key? key, required this.temperature}) : super(key: key);

  double get temperatureFahrenheit => (temperature * 9 / 5) + 32;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return SimpleGlassCard(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // Celsius
          _TemperatureUnit(
            value: temperature,
            unit: l10n.degreesCelsius,
            suffix: '°C',
          ),
          // Séparateur
          Container(
            height: 60,
            width: 1,
            color: AppColors.glassBorder,
          ),
          // Fahrenheit
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
