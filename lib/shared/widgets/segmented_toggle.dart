import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// Segmented toggle button matching Figma design
/// Used for Auto/Manual mode selection
class SegmentedToggle<T> extends StatelessWidget {
  final List<SegmentedToggleOption<T>> options;
  final T selectedValue;
  final ValueChanged<T> onChanged;
  final bool enabled;

  const SegmentedToggle({
    super.key,
    required this.options,
    required this.selectedValue,
    required this.onChanged,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.glassSurface,
        borderRadius: AppRadius.borderRadiusMd,
        border: Border.all(color: AppColors.glassBorder, width: 1),
      ),
      child: Row(
        children: options.map((option) {
          final isSelected = option.value == selectedValue;
          return Expanded(
            child: _ToggleButton(
              label: option.label,
              isSelected: isSelected,
              enabled: enabled,
              isFirst: option == options.first,
              isLast: option == options.last,
              onTap: () => onChanged(option.value),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class SegmentedToggleOption<T> {
  final T value;
  final String label;

  const SegmentedToggleOption({
    required this.value,
    required this.label,
  });
}

class _ToggleButton extends StatelessWidget {
  final String label;
  final bool isSelected;
  final bool enabled;
  final bool isFirst;
  final bool isLast;
  final VoidCallback onTap;

  const _ToggleButton({
    required this.label,
    required this.isSelected,
    required this.enabled,
    required this.isFirst,
    required this.isLast,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final borderRadius = BorderRadius.horizontal(
      left: isFirst ? const Radius.circular(AppRadius.md) : Radius.zero,
      right: isLast ? const Radius.circular(AppRadius.md) : Radius.zero,
    );

    return Opacity(
      opacity: enabled ? 1.0 : 0.5,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: enabled ? onTap : null,
          borderRadius: borderRadius,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(
              vertical: AppSpacing.md,
              horizontal: AppSpacing.sm,
            ),
            decoration: BoxDecoration(
              color: isSelected ? AppColors.primary : Colors.transparent,
              borderRadius: borderRadius,
            ),
            child: Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: isSelected
                    ? AppColors.backgroundDark
                    : AppColors.textSecondary,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
