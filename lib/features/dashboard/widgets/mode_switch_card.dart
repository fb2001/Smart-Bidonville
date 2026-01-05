import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/models/fan_mode.dart';
import '../viewmodel/dashboard_provider.dart';

class ModeSwitchCard extends StatelessWidget {
  const ModeSwitchCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<DashboardProvider>(
      builder: (context, provider, _) {
        final currentMode = provider.state.fanStatus?.mode ?? FanMode.manual;

        return Card(
          elevation: 4,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Control Mode',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: _ModeButton(
                        mode: FanMode.manual,
                        isSelected: currentMode.isManual,
                        onTap: () => provider.setMode(FanMode.manual),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _ModeButton(
                        mode: FanMode.auto,
                        isSelected: currentMode.isAuto,
                        onTap: () => provider.setMode(FanMode.auto),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _ModeButton extends StatelessWidget {
  final FanMode mode;
  final bool isSelected;
  final VoidCallback onTap;

  const _ModeButton({
    required this.mode,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: isSelected ? Colors.blueAccent : Colors.grey.shade800,
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          child: Column(
            children: [
              Icon(
                mode.isAuto ? Icons.autorenew : Icons.touch_app,
                color: isSelected ? Colors.white : Colors.grey.shade500,
                size: 32,
              ),
              const SizedBox(height: 8),
              Text(
                mode.displayName,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: isSelected ? Colors.white : Colors.grey.shade500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
