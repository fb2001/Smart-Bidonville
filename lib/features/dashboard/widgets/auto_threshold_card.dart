import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../../core/models/temperature_thresholds.dart';
import '../../../shared/widgets/ios_card.dart';
import '../../../shared/theme/ios_theme.dart';
import '../viewmodel/dashboard_provider.dart';

class AutoThresholdCard extends StatefulWidget {
  const AutoThresholdCard({super.key});

  @override
  State<AutoThresholdCard> createState() => _AutoThresholdCardState();
}

class _AutoThresholdCardState extends State<AutoThresholdCard> {
  late double _slowThreshold;
  late double _mediumThreshold;
  late double _fastThreshold;

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
    return Consumer<DashboardProvider>(
      builder: (context, provider, _) {
        final isAutoMode = provider.state.fanStatus?.mode.isAuto ?? false;

        return IOSCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.tune_rounded,
                    size: 20,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  const SizedBox(width: IOSTheme.spacing8),
                  Text(
                    'Auto Mode Thresholds',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const Spacer(),
                  if (!isAutoMode)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: IOSTheme.spacing12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: IOSTheme.dangerColor.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(IOSTheme.radiusSmall),
                        border: Border.all(
                          color: IOSTheme.dangerColor.withValues(alpha: 0.3),
                          width: 1,
                        ),
                      ),
                      child: Text(
                        'DISABLED',
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: IOSTheme.dangerColor,
                            ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: IOSTheme.spacing16),

              // Slow threshold slider
              _ThresholdSlider(
                label: 'Slow Speed',
                color: const Color(0xFFFF3B30), // iOS Red
                value: _slowThreshold,
                onChanged: isAutoMode
                    ? (val) {
                        HapticFeedback.selectionClick();
                        setState(() {
                          _slowThreshold = val;
                        });
                      }
                    : null,
              ),

              const SizedBox(height: IOSTheme.spacing12),

              // Medium threshold slider
              _ThresholdSlider(
                label: 'Medium Speed',
                color: const Color(0xFF007AFF), // iOS Blue
                value: _mediumThreshold,
                onChanged: isAutoMode
                    ? (val) {
                        HapticFeedback.selectionClick();
                        setState(() {
                          _mediumThreshold = val;
                        });
                      }
                    : null,
              ),

              const SizedBox(height: IOSTheme.spacing12),

              // Fast threshold slider
              _ThresholdSlider(
                label: 'Fast Speed',
                color: const Color(0xFF34C759), // iOS Green
                value: _fastThreshold,
                onChanged: isAutoMode
                    ? (val) {
                        HapticFeedback.selectionClick();
                        setState(() {
                          _fastThreshold = val;
                        });
                      }
                    : null,
              ),

              const SizedBox(height: IOSTheme.spacing16),

              // Validation message
              if (!_isValid)
                Padding(
                  padding: const EdgeInsets.only(bottom: IOSTheme.spacing12),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.warning_rounded,
                        color: Color(0xFFFF9500), // iOS Orange
                        size: 20,
                      ),
                      const SizedBox(width: IOSTheme.spacing8),
                      Expanded(
                        child: Text(
                          'Thresholds must satisfy: Slow < Medium < Fast',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: const Color(0xFFFF9500),
                              ),
                        ),
                      ),
                    ],
                  ),
                ),

              // Apply button
              IOSButton(
                text: 'Apply Thresholds',
                onPressed: (isAutoMode && _isValid)
                    ? () async {
                        final thresholds = TemperatureThresholds(
                          slow: _slowThreshold,
                          medium: _mediumThreshold,
                          fast: _fastThreshold,
                        );
                        final success = await provider.setThresholds(thresholds);
                        if (success && context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: const Text('Thresholds updated successfully'),
                              backgroundColor: IOSTheme.accentColor,
                              behavior: SnackBarBehavior.floating,
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(IOSTheme.radiusMedium),
                              ),
                              margin: const EdgeInsets.all(IOSTheme.spacing16),
                            ),
                          );
                        }
                      }
                    : null,
                isPrimary: true,
                icon: Icons.check_circle_rounded,
              ),
            ],
          ),
        );
      },
    );
  }
}

class _ThresholdSlider extends StatelessWidget {
  final String label;
  final Color color;
  final double value;
  final ValueChanged<double>? onChanged;

  const _ThresholdSlider({
    required this.label,
    required this.color,
    required this.value,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: IOSTheme.spacing8),
            Text(
              label,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
            ),
            const Spacer(),
            Text(
              '${value.toStringAsFixed(1)}°C',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
            ),
          ],
        ),
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            activeTrackColor: color,
            inactiveTrackColor: color.withValues(alpha: 0.2),
            thumbColor: color,
            overlayColor: color.withValues(alpha: 0.2),
            trackHeight: 4,
            thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 8),
          ),
          child: Slider(
            value: value,
            min: 0,
            max: 50,
            divisions: 100,
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }
}
