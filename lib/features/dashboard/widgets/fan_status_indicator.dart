import 'package:flutter/material.dart';
import '../../../core/models/fan_status.dart';
import '../../../shared/widgets/ios_card.dart';
import '../../../shared/theme/ios_theme.dart';

class FanStatusIndicator extends StatelessWidget {
  final FanStatus fanStatus;

  const FanStatusIndicator({super.key, required this.fanStatus});

  @override
  Widget build(BuildContext context) {
    final isRunning = fanStatus.isFanRunning;
    final color = fanStatus.color.toColor();

    return IOSCard(
      child: Row(
        children: [
          // Fan icon with colored background
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(IOSTheme.radiusMedium),
            ),
            child: Icon(
              isRunning ? Icons.air_rounded : Icons.power_off_rounded,
              color: color,
              size: 32,
            ),
          ),
          const SizedBox(width: IOSTheme.spacing16),

          // Fan status info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isRunning ? 'Fan Running' : 'Fan Off',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(height: IOSTheme.spacing4),
                if (isRunning)
                  Text(
                    'Speed: ${fanStatus.speed!.displayName}',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context)
                              .colorScheme
                              .onSurface
                              .withValues(alpha: 0.6),
                        ),
                  ),
                Text(
                  'Mode: ${fanStatus.mode.displayName}',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context)
                            .colorScheme
                            .onSurface
                            .withValues(alpha: 0.6),
                      ),
                ),
              ],
            ),
          ),

          // Color indicator
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(IOSTheme.radiusSmall),
              boxShadow: [
                BoxShadow(
                  color: color.withValues(alpha: 0.3),
                  blurRadius: 8,
                  spreadRadius: 1,
                ),
              ],
            ),
            child: Center(
              child: Text(
                fanStatus.color.toString().substring(3), // Remove "RGB"
                style: const TextStyle(
                  fontSize: 8,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
