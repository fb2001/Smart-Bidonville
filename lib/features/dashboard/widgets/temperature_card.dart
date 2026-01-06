import 'package:flutter/material.dart';
import '../../../shared/widgets/ios_card.dart';
import '../../../shared/theme/ios_theme.dart';

class TemperatureCard extends StatelessWidget {
  final double temperature;

  const TemperatureCard({super.key, required this.temperature});

  Color _getTemperatureColor() {
    if (temperature < 20) return const Color(0xFF007AFF); // iOS Blue
    if (temperature < 25) return const Color(0xFF34C759); // iOS Green
    if (temperature < 30) return const Color(0xFFFF9500); // iOS Orange
    return const Color(0xFFFF3B30); // iOS Red
  }

  IconData _getTemperatureIcon() {
    if (temperature < 20) return Icons.ac_unit_rounded;
    if (temperature < 30) return Icons.thermostat_rounded;
    return Icons.local_fire_department_rounded;
  }

  @override
  Widget build(BuildContext context) {
    final color = _getTemperatureColor();

    return IOSCard(
      child: Row(
        children: [
          // Icon with circle background
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: color.withOpacity(0.15),
              borderRadius: BorderRadius.circular(IOSTheme.radiusMedium),
            ),
            child: Icon(
              _getTemperatureIcon(),
              size: 32,
              color: color,
            ),
          ),

          const SizedBox(width: IOSTheme.spacing16),

          // Temperature info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Current Temperature',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context)
                            .colorScheme
                            .onSurface
                            .withOpacity(0.6),
                      ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${temperature.toStringAsFixed(1)}°C',
                  style: Theme.of(context).textTheme.displayMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: color,
                        height: 1.0,
                      ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
