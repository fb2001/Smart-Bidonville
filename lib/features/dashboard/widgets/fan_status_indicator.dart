import 'package:flutter/material.dart';
import '../../../core/models/fan_status.dart';

class FanStatusIndicator extends StatelessWidget {
  final FanStatus fanStatus;

  const FanStatusIndicator({Key? key, required this.fanStatus}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isRunning = fanStatus.isFanRunning;
    final color = fanStatus.color.toColor();

    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: color.withOpacity(0.3),
                shape: BoxShape.circle,
                border: Border.all(color: color, width: 3),
              ),
              child: Icon(
                isRunning ? Icons.air : Icons.power_off,
                color: color,
                size: 32,
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    isRunning ? 'Fan Running' : 'Fan Off',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  if (isRunning)
                    Text(
                      'Speed: ${fanStatus.speed!.displayName}',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade400,
                      ),
                    ),
                  Text(
                    'Mode: ${fanStatus.mode.displayName}',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade400,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
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
      ),
    );
  }
}
