import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/models/fan_mode.dart';
import '../../../shared/theme/app_theme.dart';
import '../../../shared/widgets/segmented_toggle.dart';
import '../viewmodel/dashboard_provider.dart';

/// Mode switch card matching Figma design
/// Segmented control for Auto/Manual mode selection
class ModeSwitchCard extends StatelessWidget {
  const ModeSwitchCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<DashboardProvider>(
      builder: (context, provider, _) {
        final currentMode = provider.state.fanStatus?.mode ?? FanMode.manual;

        return SegmentedToggle<FanMode>(
          options: const [
            SegmentedToggleOption(
              value: FanMode.auto,
              label: 'Automatique',
            ),
            SegmentedToggleOption(
              value: FanMode.manual,
              label: 'Manuel',
            ),
          ],
          selectedValue: currentMode,
          onChanged: (mode) => provider.setMode(mode),
        );
      },
    );
  }
}
