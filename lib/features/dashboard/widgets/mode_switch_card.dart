import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../../core/models/fan_mode.dart';
import '../../../shared/widgets/ios_card.dart';
import '../../../shared/theme/ios_theme.dart';
import '../viewmodel/dashboard_provider.dart';

class ModeSwitchCard extends StatelessWidget {
  const ModeSwitchCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<DashboardProvider>(
      builder: (context, provider, _) {
        final currentMode = provider.state.fanStatus?.mode ?? FanMode.manual;

        return IOSCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.settings_rounded,
                    size: 20,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  const SizedBox(width: IOSTheme.spacing8),
                  Text(
                    'Control Mode',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                ],
              ),
              const SizedBox(height: IOSTheme.spacing16),

              // iOS-style segmented control
              Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).brightness == Brightness.dark
                      ? IOSTheme.tertiaryBackgroundDark
                      : IOSTheme.secondaryBackgroundLight,
                  borderRadius: BorderRadius.circular(IOSTheme.radiusSmall),
                ),
                child: CupertinoSegmentedControl<FanMode>(
                  children: {
                    FanMode.manual: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: IOSTheme.spacing16,
                        vertical: IOSTheme.spacing12,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.touch_app_rounded,
                            size: 18,
                            color: currentMode.isManual
                                ? Colors.white
                                : Theme.of(context).colorScheme.onSurface,
                          ),
                          const SizedBox(width: IOSTheme.spacing8),
                          Text(
                            'Manual',
                            style: TextStyle(
                              color: currentMode.isManual
                                  ? Colors.white
                                  : Theme.of(context).colorScheme.onSurface,
                            ),
                          ),
                        ],
                      ),
                    ),
                    FanMode.auto: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: IOSTheme.spacing16,
                        vertical: IOSTheme.spacing12,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.autorenew_rounded,
                            size: 18,
                            color: currentMode.isAuto
                                ? Colors.white
                                : Theme.of(context).colorScheme.onSurface,
                          ),
                          const SizedBox(width: IOSTheme.spacing8),
                          Text(
                            'Auto',
                            style: TextStyle(
                              color: currentMode.isAuto
                                  ? Colors.white
                                  : Theme.of(context).colorScheme.onSurface,
                            ),
                          ),
                        ],
                      ),
                    ),
                  },
                  groupValue: currentMode,
                  onValueChanged: (FanMode? value) {
                    if (value != null) {
                      HapticFeedback.selectionClick();
                      provider.setMode(value);
                    }
                  },
                  selectedColor: Theme.of(context).colorScheme.primary,
                  unselectedColor: Colors.transparent,
                  borderColor: Colors.transparent,
                  pressedColor: Theme.of(context)
                      .colorScheme
                      .primary
                      .withOpacity(0.2),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
