import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/models/fan_mode.dart';
import '../../../shared/widgets/segmented_toggle.dart';
import '../../../l10n/app_localizations.dart';
import '../viewmodel/dashboard_provider.dart';

/// Mode switch card matching Figma design
/// Segmented control for Auto/Manual mode selection
class ModeSwitchCard extends StatelessWidget {
  const ModeSwitchCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Consumer<DashboardProvider>(
      builder: (context, provider, _) {
        final currentMode = provider.state.fanStatus?.mode ?? FanMode.manual;

        return SegmentedToggle<FanMode>(
          options: [
            SegmentedToggleOption(
              value: FanMode.auto,
              label: l10n.fanModeAuto,
            ),
            SegmentedToggleOption(
              value: FanMode.manual,
              label: l10n.fanModeManual,
            ),
          ],
          selectedValue: currentMode,
          onChanged: (mode) => provider.setMode(mode),
        );
      },
    );
  }
}
