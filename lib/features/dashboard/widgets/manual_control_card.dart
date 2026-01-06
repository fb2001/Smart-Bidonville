import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../../core/models/fan_speed.dart';
import '../../../core/models/rgb_color.dart';
import '../../../shared/widgets/ios_card.dart';
import '../../../shared/theme/ios_theme.dart';
import '../viewmodel/dashboard_provider.dart';

class ManualControlCard extends StatefulWidget {
  const ManualControlCard({super.key});

  @override
  State<ManualControlCard> createState() => _ManualControlCardState();
}

class _ManualControlCardState extends State<ManualControlCard> {
  FanSpeed _selectedSpeed = FanSpeed.slow;

  @override
  Widget build(BuildContext context) {
    return Consumer<DashboardProvider>(
      builder: (context, provider, _) {
        final isManualMode = provider.state.fanStatus?.mode.isManual ?? false;

        return IOSCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.touch_app_rounded,
                    size: 20,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  const SizedBox(width: IOSTheme.spacing8),
                  Text(
                    'Manual Control',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const Spacer(),
                  if (!isManualMode)
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

              // Speed selector
              Column(
                children: FanSpeed.values.map((speed) {
                  return _SpeedSelectionTile(
                    speed: speed,
                    isSelected: _selectedSpeed == speed,
                    isEnabled: isManualMode,
                    onSelect: (selected) {
                      HapticFeedback.selectionClick();
                      setState(() {
                        _selectedSpeed = selected;
                      });
                    },
                  );
                }).toList(),
              ),

              const SizedBox(height: IOSTheme.spacing16),

              // Apply button
              IOSButton(
                text: 'Apply Speed',
                onPressed: isManualMode
                    ? () async {
                        final success = await provider.setManualSpeed(_selectedSpeed);
                        if (success && context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                  'Fan speed set to ${_selectedSpeed.displayName}'),
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

class _SpeedSelectionTile extends StatelessWidget {
  final FanSpeed speed;
  final bool isSelected;
  final bool isEnabled;
  final ValueChanged<FanSpeed> onSelect;

  const _SpeedSelectionTile({
    required this.speed,
    required this.isSelected,
    required this.isEnabled,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    final color = RgbColor.fromSpeed(speed);
    final brightness = Theme.of(context).brightness;
    final bgColor = brightness == Brightness.dark
        ? IOSTheme.tertiaryBackgroundDark
        : IOSTheme.secondaryBackgroundLight;

    return Padding(
      padding: const EdgeInsets.only(bottom: IOSTheme.spacing8),
      child: Opacity(
        opacity: isEnabled ? 1.0 : 0.5,
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: isEnabled ? () => onSelect(speed) : null,
            borderRadius: BorderRadius.circular(IOSTheme.radiusMedium),
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: IOSTheme.spacing16,
                vertical: IOSTheme.spacing12,
              ),
              decoration: BoxDecoration(
                color: isSelected
                    ? Theme.of(context).colorScheme.primary.withValues(alpha: 0.1)
                    : bgColor,
                borderRadius: BorderRadius.circular(IOSTheme.radiusMedium),
                border: Border.all(
                  color: isSelected
                      ? Theme.of(context).colorScheme.primary
                      : Colors.transparent,
                  width: 2,
                ),
              ),
              child: Row(
                children: [
                  // Selection indicator
                  Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: isSelected
                            ? Theme.of(context).colorScheme.primary
                            : Theme.of(context)
                                .colorScheme
                                .onSurface
                                .withValues(alpha: 0.3),
                        width: 2,
                      ),
                      color: isSelected
                          ? Theme.of(context).colorScheme.primary
                          : Colors.transparent,
                    ),
                    child: isSelected
                        ? const Icon(
                            Icons.check,
                            size: 16,
                            color: Colors.white,
                          )
                        : null,
                  ),
                  const SizedBox(width: IOSTheme.spacing12),

                  // Color indicator
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: color.toColor(),
                      borderRadius: BorderRadius.circular(IOSTheme.radiusSmall),
                      boxShadow: [
                        BoxShadow(
                          color: color.toColor().withValues(alpha: 0.3),
                          blurRadius: 4,
                          spreadRadius: 1,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: IOSTheme.spacing12),

                  // Speed name
                  Expanded(
                    child: Text(
                      speed.displayName,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            fontWeight:
                                isSelected ? FontWeight.w600 : FontWeight.normal,
                          ),
                    ),
                  ),

                  // RGB value
                  Text(
                    'RGB(${color.red},${color.green},${color.blue})',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context)
                              .colorScheme
                              .onSurface
                              .withValues(alpha: 0.5),
                          fontWeight: FontWeight.w500,
                        ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
