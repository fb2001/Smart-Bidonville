import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/models/fan_speed.dart';
import '../../../core/models/temperature_thresholds.dart';
import '../../../l10n/app_localizations.dart';
import '../../../shared/theme/app_theme.dart';
import '../../../shared/widgets/glass_card.dart';
import '../../../shared/widgets/app_button.dart';
import '../../../shared/widgets/threshold_input.dart';
import '../viewmodel/dashboard_provider.dart';

/// Auto threshold card matching Figma design
/// Shows threshold inputs for Slow/Medium/Fast speed levels
class AutoThresholdCard extends StatefulWidget {
  const AutoThresholdCard({Key? key}) : super(key: key);

  @override
  State<AutoThresholdCard> createState() => _AutoThresholdCardState();
}

class _AutoThresholdCardState extends State<AutoThresholdCard> {
  late double _slowThreshold;
  late double _mediumThreshold;
  late double _fastThreshold;
  bool _isApplying = false;

  @override
  void initState() {
    super.initState();
    final thresholds = context.read<DashboardProvider>().state.thresholds;
    _slowThreshold = thresholds.slow;
    _mediumThreshold = thresholds.medium;
    _fastThreshold = thresholds.fast;
  }

  bool get _isValid {
    return _slowThreshold < _mediumThreshold && _mediumThreshold < _fastThreshold;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Consumer<DashboardProvider>(
      builder: (context, provider, _) {
        final isAutoMode = provider.state.fanStatus?.mode.isAuto ?? false;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Threshold inputs
            ThresholdInput(
              speedLevel: FanSpeed.slow,
              value: _slowThreshold,
              onChanged: (val) => setState(() => _slowThreshold = val),
              enabled: isAutoMode,
            ),
            const SizedBox(height: AppSpacing.sm),

            ThresholdInput(
              speedLevel: FanSpeed.medium,
              value: _mediumThreshold,
              onChanged: (val) => setState(() => _mediumThreshold = val),
              enabled: isAutoMode,
            ),
            const SizedBox(height: AppSpacing.sm),

            ThresholdInput(
              speedLevel: FanSpeed.fast,
              value: _fastThreshold,
              onChanged: (val) => setState(() => _fastThreshold = val),
              enabled: isAutoMode,
            ),

            const SizedBox(height: AppSpacing.md),

            // Validation message
            if (!_isValid && isAutoMode)
              Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.md),
                child: SimpleGlassCard(
                  padding: const EdgeInsets.all(AppSpacing.sm),
                  backgroundColor: AppColors.warning.withOpacity(0.2),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.warning_amber_rounded,
                        color: AppColors.warning,
                        size: 20,
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      Expanded(
                        child: Text(
                          l10n.thresholdsConstraint,
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.warning,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

            // Bouton enregistrer
            PrimaryButton(
              text: l10n.save,
              isLoading: _isApplying,
              onPressed: (isAutoMode && _isValid)
                  ? () async {
                      setState(() => _isApplying = true);

                      final thresholds = TemperatureThresholds(
                        slow: _slowThreshold,
                        medium: _mediumThreshold,
                        fast: _fastThreshold,
                      );
                      final success = await provider.setThresholds(thresholds);

                      setState(() => _isApplying = false);

                      if (success && context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(l10n.thresholdsUpdated),
                            backgroundColor: AppColors.success,
                            duration: const Duration(seconds: 2),
                          ),
                        );
                      }
                    }
                  : null,
            ),
          ],
        );
      },
    );
  }
}
