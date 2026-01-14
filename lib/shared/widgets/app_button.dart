import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// Primary button matching Figma design
class PrimaryButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final double? width;
  final IconData? icon;

  const PrimaryButton({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.width,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width ?? double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.backgroundDark,
          disabledBackgroundColor: AppColors.primary.withOpacity(0.5),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: AppRadius.borderRadiusMd,
          ),
        ),
        child: isLoading
            ? const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: AppColors.backgroundDark,
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (icon != null) ...[
                    Icon(icon, size: 20),
                    const SizedBox(width: AppSpacing.sm),
                  ],
                  Flexible(
                    child: Text(
                      text,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}

/// Secondary outlined button
class SecondaryButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final double? width;
  final IconData? icon;

  const SecondaryButton({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.width,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width ?? double.infinity,
      height: 56,
      child: OutlinedButton(
        onPressed: isLoading ? null : onPressed,
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.textPrimary,
          side: const BorderSide(color: AppColors.glassBorder, width: 1.5),
          shape: RoundedRectangleBorder(
            borderRadius: AppRadius.borderRadiusMd,
          ),
        ),
        child: isLoading
            ? const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: AppColors.textPrimary,
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (icon != null) ...[
                    Icon(icon, size: 20),
                    const SizedBox(width: AppSpacing.sm),
                  ],
                  Flexible(
                    child: Text(
                      text,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}

/// Icon button with glass background
class GlassIconButton extends StatelessWidget {
  final IconData? icon;
  final String? assetPath;
  final VoidCallback? onPressed;
  final double size;
  final Color? iconColor;

  const GlassIconButton({
    super.key,
    this.icon,
    this.assetPath,
    this.onPressed,
    this.size = 48,
    this.iconColor,
  }) : assert(icon != null || assetPath != null, 'Either icon or assetPath must be provided');

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(size / 2),
        child: Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            color: AppColors.glassSurface,
            shape: BoxShape.circle,
            border: Border.all(color: AppColors.glassBorder, width: 1),
          ),
          child: assetPath != null
              ? Padding(
                  padding: EdgeInsets.all(size * 0.2),
                  child: Image.asset(
                    assetPath!,
                    color: iconColor ?? AppColors.textPrimary,
                    width: size * 0.5,
                    height: size * 0.5,
                  ),
                )
              : Icon(
                  icon,
                  color: iconColor ?? AppColors.textPrimary,
                  size: size * 0.5,
                ),
        ),
      ),
    );
  }
}

/// Social login button (e.g., Google)
class SocialButton extends StatelessWidget {
  final String assetPath;
  final VoidCallback? onPressed;
  final double size;

  const SocialButton({
    super.key,
    required this.assetPath,
    this.onPressed,
    this.size = 52,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(size / 2),
        child: Container(
          width: size,
          height: size,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Image.asset(
            assetPath,
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
}
