import 'package:flutter/material.dart';
import '../theme/ios_theme.dart';

/// iOS-style card with glassmorphism effect
/// Follows iOS 17 design language
class IOSCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final Color? backgroundColor;
  final VoidCallback? onTap;
  final double? height;

  const IOSCard({
    super.key,
    required this.child,
    this.padding,
    this.backgroundColor,
    this.onTap,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final defaultBg = isDark
        ? IOSTheme.secondaryBackgroundDark
        : IOSTheme.backgroundLight;

    Widget card = Container(
      height: height,
      padding: padding ?? const EdgeInsets.all(IOSTheme.spacing16),
      decoration: BoxDecoration(
        color: backgroundColor ?? defaultBg,
        borderRadius: BorderRadius.circular(IOSTheme.radiusLarge),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.3 : 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: child,
    );

    if (onTap != null) {
      return GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: card,
      );
    }

    return card;
  }
}

/// iOS-style section header
class IOSSectionHeader extends StatelessWidget {
  final String title;
  final Widget? trailing;

  const IOSSectionHeader({
    super.key,
    required this.title,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: IOSTheme.spacing16,
        vertical: IOSTheme.spacing8,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title.toUpperCase(),
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context)
                      .colorScheme
                      .onSurface
                      .withOpacity(0.6),
                  letterSpacing: 0.5,
                ),
          ),
          if (trailing != null) trailing!,
        ],
      ),
    );
  }
}

/// iOS-style list tile (for settings, etc.)
class IOSListTile extends StatelessWidget {
  final IconData? leadingIcon;
  final String title;
  final String? subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;
  final bool showChevron;

  const IOSListTile({
    super.key,
    this.leadingIcon,
    required this.title,
    this.subtitle,
    this.trailing,
    this.onTap,
    this.showChevron = true,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: IOSTheme.spacing16,
          vertical: IOSTheme.spacing12,
        ),
        child: Row(
          children: [
            if (leadingIcon != null) ...[
              Icon(
                leadingIcon,
                size: 28,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(width: IOSTheme.spacing16),
            ],
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  if (subtitle != null) ...[
                    const SizedBox(height: 2),
                    Text(
                      subtitle!,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Theme.of(context)
                                .colorScheme
                                .onSurface
                                .withOpacity(0.6),
                          ),
                    ),
                  ],
                ],
              ),
            ),
            if (trailing != null)
              trailing!
            else if (showChevron && onTap != null)
              Icon(
                Icons.chevron_right,
                color: Theme.of(context)
                    .colorScheme
                    .onSurface
                    .withOpacity(0.3),
              ),
          ],
        ),
      ),
    );
  }
}

/// iOS-style button with haptic feedback
class IOSButton extends StatefulWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isPrimary;
  final bool isDestructive;
  final IconData? icon;

  const IOSButton({
    super.key,
    required this.text,
    this.onPressed,
    this.isPrimary = true,
    this.isDestructive = false,
    this.icon,
  });

  @override
  State<IOSButton> createState() => _IOSButtonState();
}

class _IOSButtonState extends State<IOSButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTapDown(TapDownDetails details) {
    _controller.forward();
  }

  void _handleTapUp(TapUpDetails details) {
    _controller.reverse();
  }

  void _handleTapCancel() {
    _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    Color backgroundColor;
    Color foregroundColor = Colors.white;

    if (widget.isDestructive) {
      backgroundColor = IOSTheme.dangerColor;
    } else if (widget.isPrimary) {
      backgroundColor = Theme.of(context).colorScheme.primary;
    } else {
      backgroundColor = Theme.of(context).colorScheme.surface;
      foregroundColor = Theme.of(context).colorScheme.primary;
    }

    return GestureDetector(
      onTapDown: widget.onPressed != null ? _handleTapDown : null,
      onTapUp: widget.onPressed != null ? _handleTapUp : null,
      onTapCancel: widget.onPressed != null ? _handleTapCancel : null,
      onTap: widget.onPressed,
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: Container(
              height: 50,
              decoration: BoxDecoration(
                color: backgroundColor.withOpacity(
                  widget.onPressed == null ? 0.5 : 1.0,
                ),
                borderRadius: BorderRadius.circular(IOSTheme.radiusMedium),
                border: !widget.isPrimary && !widget.isDestructive
                    ? Border.all(
                        color: Theme.of(context).colorScheme.primary,
                        width: 1.5,
                      )
                    : null,
              ),
              alignment: Alignment.center,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (widget.icon != null) ...[
                    Icon(
                      widget.icon,
                      color: foregroundColor,
                      size: 20,
                    ),
                    const SizedBox(width: IOSTheme.spacing8),
                  ],
                  Text(
                    widget.text,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: foregroundColor,
                        ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
