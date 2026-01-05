import 'package:flutter/material.dart';

class TemperatureCard extends StatelessWidget {
  final double temperature;

  const TemperatureCard({Key? key, required this.temperature}) : super(key: key);

  Color _getTemperatureColor() {
    if (temperature < 20) return Colors.blue;
    if (temperature < 25) return Colors.green;
    if (temperature < 30) return Colors.orange;
    return Colors.red;
  }

  IconData _getTemperatureIcon() {
    if (temperature < 20) return Icons.ac_unit;
    if (temperature < 30) return Icons.thermostat;
    return Icons.local_fire_department;
  }

  @override
  Widget build(BuildContext context) {
    final color = _getTemperatureColor();

    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Icon(
              _getTemperatureIcon(),
              size: 48,
              color: color,
            ),
            const SizedBox(height: 12),
            Text(
              '${temperature.toStringAsFixed(1)}°C',
              style: TextStyle(
                fontSize: 42,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Current Temperature',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
