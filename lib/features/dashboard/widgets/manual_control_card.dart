import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/models/fan_speed.dart';
import '../../../shared/theme/app_theme.dart';
import '../../../shared/widgets/glass_card.dart';
import '../../../shared/widgets/app_button.dart';
import '../viewmodel/dashboard_provider.dart';

/// Manual control card matching Figma design
/// Speed selector with Slow/Medium/Fast options using asset icons
class ManualControlCard extends StatefulWidget {
  const ManualControlCard({Key? key}) : super(key: key);

  @override
  State<ManualControlCard> createState() => _ManualControlCardState();
}

class _ManualControlCardState extends State<ManualControlCard> {
  FanSpeed _selectedSpeed = FanSpeed.slow;
  bool _isApplying = false;

  @override
  Widget build(BuildContext context) {
    return Consumer<DashboardProvider>(
      builder: (context, provider, _) {
        final isManualMode = provider.state.fanStatus?.mode.isManual ?? false;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Status label
            if (!isManualMode)
              Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                child: Text(
                  'Ventilateur manual mode',
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.textMuted,
                  ),
                ),
              ),

            // Speed options
            ...FanSpeed.values.map((speed) => Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.sm),
              child: _SpeedOptionTile(
                speed: speed,
                isSelected: _selectedSpeed == speed,
                isEnabled: isManualMode,
                onTap: () {
                  setState(() {
                    _selectedSpeed = speed;
                  });
                },
              ),
            )),

            const SizedBox(height: AppSpacing.md),

            // Apply button (hidden in auto mode per Figma)
            if (isManualMode)
              PrimaryButton(
                text: 'Save',
                isLoading: _isApplying,
                onPressed: () async {
                  setState(() => _isApplying = true);
                  final success = await provider.setManualSpeed(_selectedSpeed);
                  setState(() => _isApplying = false);

                  if (success && context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Fan speed set to ${_selectedSpeed.displayName}'),
                        backgroundColor: AppColors.success,
                        duration: const Duration(seconds: 2),
                      ),
                    );
                  }
                },
              ),
          ],
        );
      },
    );
  }
}

class _SpeedOptionTile extends StatelessWidget {
  final FanSpeed speed;
  final bool isSelected;
  final bool isEnabled;
  final VoidCallback onTap;

  const _SpeedOptionTile({
    required this.speed,
    required this.isSelected,
    required this.isEnabled,
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
      opacity: isEnabled ? 1.0 : 0.5,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: isEnabled ? onTap : null,
          borderRadius: AppRadius.borderRadiusMd,
          child: SimpleGlassCard(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.sm,
            ),
            backgroundColor: isSelected
                ? AppColors.glassSurface
                : Colors.transparent,
            child: Row(
              children: [
                // Speed icon from assets
                Container(
                  width: 40,
                  height: 40,
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? _speedColor.withOpacity(0.2)
                        : AppColors.glassSurface,
                    borderRadius: AppRadius.borderRadiusSm,
                  ),
                  child: Image.asset(
                    _iconAsset,
                    color: isSelected ? _speedColor : AppColors.textMuted,
                    errorBuilder: (context, error, stackTrace) {
                      return Icon(
                        Icons.speed,
                        color: isSelected ? _speedColor : AppColors.textMuted,
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
}
