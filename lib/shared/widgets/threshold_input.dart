import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../core/models/fan_speed.dart';
import '../../l10n/app_localizations.dart';
import '../localization/fan_localizations.dart';
import '../theme/app_theme.dart';

/// Threshold input widget for auto mode temperature settings
/// Matches Figma design with icon + label + input field
class ThresholdInput extends StatelessWidget {
  final FanSpeed speedLevel;
  final double value;
  final ValueChanged<double> onChanged;
  final bool enabled;

  const ThresholdInput({
    super.key,
    required this.speedLevel,
    required this.value,
    required this.onChanged,
    this.enabled = true,
  });

  String get _iconAsset {
    switch (speedLevel) {
      case FanSpeed.slow:
        return 'assets/icons8-escargot-50.png';
      case FanSpeed.medium:
        return 'assets/icons8-vitesse-50.png';
      case FanSpeed.fast:
        return 'assets/icons8-vitesse-maximum-50.png';
    }
  }

  Color get _speedColor {
    switch (speedLevel) {
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
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        ),
        decoration: BoxDecoration(
          color: AppColors.glassSurface,
          borderRadius: AppRadius.borderRadiusMd,
          border: Border.all(color: AppColors.glassBorder, width: 1),
        ),
        child: Row(
          children: [
            // Speed icon
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
                    Icons.thermostat,
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
                speedLevel.localizedName(AppLocalizations.of(context)!),
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
            // Temperature input
            SizedBox(
              width: 120,
              child: _DegreeInputField(
                value: value,
                onChanged: onChanged,
                enabled: enabled,
                color: _speedColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DegreeInputField extends StatefulWidget {
  final double value;
  final ValueChanged<double> onChanged;
  final bool enabled;
  final Color color;

  const _DegreeInputField({
    required this.value,
    required this.onChanged,
    required this.enabled,
    required this.color,
  });

  @override
  State<_DegreeInputField> createState() => _DegreeInputFieldState();
}

class _DegreeInputFieldState extends State<_DegreeInputField> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(
      text: widget.value.toStringAsFixed(0),
    );
  }

  @override
  void didUpdateWidget(_DegreeInputField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value) {
      final newText = widget.value.toStringAsFixed(0);
      if (_controller.text != newText) {
        _controller.text = newText;
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.glassSurface,
        borderRadius: AppRadius.borderRadiusSm,
        border: Border.all(color: AppColors.glassBorder, width: 1),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _controller,
              enabled: widget.enabled,
              keyboardType: TextInputType.number,
              textInputAction: TextInputAction.done,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: widget.color,
              ),
              decoration: const InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(
                  horizontal: AppSpacing.sm,
                  vertical: AppSpacing.sm,
                ),
                isDense: true,
              ),
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(2),
              ],
              onChanged: (text) {
                final parsed = double.tryParse(text);
                if (parsed != null && parsed >= 0 && parsed <= 50) {
                  widget.onChanged(parsed);
                }
              },
              onSubmitted: (_) => FocusScope.of(context).unfocus(),
            ),
          ),
          Container(
            padding: const EdgeInsets.only(right: AppSpacing.sm),
            child: Text(
              '°C',
              style: TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Slider-based threshold input for alternative UI
class ThresholdSlider extends StatelessWidget {
  final String label;
  final FanSpeed speedLevel;
  final double value;
  final ValueChanged<double>? onChanged;
  final double min;
  final double max;

  const ThresholdSlider({
    super.key,
    required this.label,
    required this.speedLevel,
    required this.value,
    this.onChanged,
    this.min = 0,
    this.max = 50,
  });

  Color get _speedColor {
    switch (speedLevel) {
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                color: _speedColor,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: AppColors.textPrimary,
              ),
            ),
            const Spacer(),
            Text(
              '${value.toStringAsFixed(0)}°C',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: _speedColor,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.xs),
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            activeTrackColor: _speedColor,
            thumbColor: _speedColor,
            inactiveTrackColor: _speedColor.withOpacity(0.2),
            overlayColor: _speedColor.withOpacity(0.2),
          ),
          child: Slider(
            value: value,
            min: min,
            max: max,
            divisions: ((max - min) * 2).toInt(),
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }
}
