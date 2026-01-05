import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/models/fan_speed.dart';
import '../../../core/models/rgb_color.dart';
import '../viewmodel/dashboard_provider.dart';

class ManualControlCard extends StatefulWidget {
  const ManualControlCard({Key? key}) : super(key: key);

  @override
  State<ManualControlCard> createState() => _ManualControlCardState();
}

class _ManualControlCardState extends State<ManualControlCard> {
  FanSpeed _selectedSpeed = FanSpeed.slow;

  @override
  Widget build(BuildContext context) {
    return Consumer<DashboardProvider>(
      builder: (context, provider, _) {
        final isManualMode = provider.state.fanStatus?.mode.isManual ?? false;

        return Card(
          elevation: 4,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Text(
                      'Manual Control',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Spacer(),
                    if (!isManualMode)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.orange.shade800,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Text(
                          'DISABLED',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 16),

                // Speed selector
                Column(
                  children: FanSpeed.values.map((speed) {
                    return _SpeedRadioTile(
                      speed: speed,
                      isSelected: _selectedSpeed == speed,
                      isEnabled: isManualMode,
                      onSelect: (selected) {
                        setState(() {
                          _selectedSpeed = selected;
                        });
                      },
                    );
                  }).toList(),
                ),

                const SizedBox(height: 16),

                // Apply button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: isManualMode
                        ? () async {
                            final success = await provider.setManualSpeed(_selectedSpeed);
                            if (success && context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Fan speed set to ${_selectedSpeed.displayName}'),
                                  backgroundColor: Colors.green,
                                  duration: const Duration(seconds: 2),
                                ),
                              );
                            }
                          }
                        : null,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: const Text('Apply Speed'),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _SpeedRadioTile extends StatelessWidget {
  final FanSpeed speed;
  final bool isSelected;
  final bool isEnabled;
  final ValueChanged<FanSpeed> onSelect;

  const _SpeedRadioTile({
    required this.speed,
    required this.isSelected,
    required this.isEnabled,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    final color = RgbColor.fromSpeed(speed);

    return Opacity(
      opacity: isEnabled ? 1.0 : 0.5,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: isEnabled ? () => onSelect(speed) : null,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Row(
              children: [
                Radio<FanSpeed>(
                  value: speed,
                  groupValue: isSelected ? speed : null,
                  onChanged: isEnabled ? (val) => onSelect(speed) : null,
                ),
                const SizedBox(width: 12),
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: color.toColor(),
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white30, width: 2),
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  speed.displayName,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
                const Spacer(),
                Text(
                  'RGB(${color.red},${color.green},${color.blue})',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade500,
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
