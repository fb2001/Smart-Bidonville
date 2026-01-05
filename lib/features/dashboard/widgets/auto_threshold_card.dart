import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/models/temperature_thresholds.dart';
import '../viewmodel/dashboard_provider.dart';

class AutoThresholdCard extends StatefulWidget {
  const AutoThresholdCard({Key? key}) : super(key: key);

  @override
  State<AutoThresholdCard> createState() => _AutoThresholdCardState();
}

class _AutoThresholdCardState extends State<AutoThresholdCard> {
  late double _slowThreshold;
  late double _mediumThreshold;
  late double _fastThreshold;

  @override
  void initState() {
    super.initState();
    final thresholds = context.read<DashboardProvider>().state.thresholds;
    _slowThreshold = thresholds.slow;
    _mediumThreshold = thresholds.medium;
    _fastThreshold = thresholds.fast;
  }

  bool get _isValid {
    return _slowThreshold < _mediumThreshold && _mediumThreshold < _fastThreshold;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<DashboardProvider>(
      builder: (context, provider, _) {
        final isAutoMode = provider.state.fanStatus?.mode.isAuto ?? false;

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
                      'Auto Mode Thresholds',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Spacer(),
                    if (!isAutoMode)
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

                // Slow threshold slider
                _ThresholdSlider(
                  label: 'Slow Speed',
                  color: Colors.red,
                  value: _slowThreshold,
                  onChanged: isAutoMode
                      ? (val) {
                          setState(() {
                            _slowThreshold = val;
                          });
                        }
                      : null,
                ),

                const SizedBox(height: 12),

                // Medium threshold slider
                _ThresholdSlider(
                  label: 'Medium Speed',
                  color: Colors.blue,
                  value: _mediumThreshold,
                  onChanged: isAutoMode
                      ? (val) {
                          setState(() {
                            _mediumThreshold = val;
                          });
                        }
                      : null,
                ),

                const SizedBox(height: 12),

                // Fast threshold slider
                _ThresholdSlider(
                  label: 'Fast Speed',
                  color: Colors.green,
                  value: _fastThreshold,
                  onChanged: isAutoMode
                      ? (val) {
                          setState(() {
                            _fastThreshold = val;
                          });
                        }
                      : null,
                ),

                const SizedBox(height: 16),

                // Validation message
                if (!_isValid)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12.0),
                    child: Row(
                      children: [
                        const Icon(Icons.warning, color: Colors.orange, size: 20),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Thresholds must satisfy: Slow < Medium < Fast',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.orange.shade300,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                // Apply button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: (isAutoMode && _isValid)
                        ? () async {
                            final thresholds = TemperatureThresholds(
                              slow: _slowThreshold,
                              medium: _mediumThreshold,
                              fast: _fastThreshold,
                            );
                            final success = await provider.setThresholds(thresholds);
                            if (success && context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Thresholds updated successfully'),
                                  backgroundColor: Colors.green,
                                  duration: Duration(seconds: 2),
                                ),
                              );
                            }
                          }
                        : null,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: const Text('Apply Thresholds'),
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

class _ThresholdSlider extends StatelessWidget {
  final String label;
  final Color color;
  final double value;
  final ValueChanged<double>? onChanged;

  const _ThresholdSlider({
    required this.label,
    required this.color,
    required this.value,
    this.onChanged,
  });

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
                color: color,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
            ),
            const Spacer(),
            Text(
              '${value.toStringAsFixed(1)}°C',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
        Slider(
          value: value,
          min: 0,
          max: 50,
          divisions: 100,
          activeColor: color,
          onChanged: onChanged,
        ),
      ],
    );
  }
}
