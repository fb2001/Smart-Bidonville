import 'dart:ui';
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// Glassmorphism card component matching the Figma design
/// Features:
/// - Semi-transparent background with blur
/// - Subtle border
/// - Rounded corners
class GlassCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double borderRadius;
  final double blurAmount;
  final Color? backgroundColor;
  final VoidCallback? onTap;

  const GlassCard({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.borderRadius = AppRadius.lg,
    this.blurAmount = 10,
    this.backgroundColor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final card = ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blurAmount, sigmaY: blurAmount),
        child: Container(
          padding: padding ?? const EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(
            color: backgroundColor ?? AppColors.glassSurface,
            borderRadius: BorderRadius.circular(borderRadius),
            border: Border.all(
              color: AppColors.glassBorder,
              width: 1,
            ),
          ),
          child: child,
        ),
      ),
    );

    if (margin != null) {
      return Padding(
        padding: margin!,
        child: onTap != null
            ? InkWell(
                onTap: onTap,
                borderRadius: BorderRadius.circular(borderRadius),
                child: card,
              )
            : card,
      );
    }

    return onTap != null
        ? InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(borderRadius),
            child: card,
          )
        : card;
  }
}

/// Simple non-blurred glass card for better performance
class SimpleGlassCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double borderRadius;
  final Color? backgroundColor;
  final VoidCallback? onTap;

  const SimpleGlassCard({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.borderRadius = AppRadius.lg,
    this.backgroundColor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    Widget card = Container(
      padding: padding ?? const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: backgroundColor ?? AppColors.glassSurface,
        borderRadius: BorderRadius.circular(borderRadius),
        border: Border.all(
          color: AppColors.glassBorder,
          width: 1,
        ),
      ),
      child: child,
    );

    if (onTap != null) {
      card = Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(borderRadius),
          child: card,
        ),
      );
    }

    if (margin != null) {
      return Padding(padding: margin!, child: card);
    }

    return card;
  }
}
