import 'package:flutter/material.dart';
import 'fan_speed.dart';

class RgbColor {
  final int red;
  final int green;
  final int blue;

  const RgbColor(this.red, this.green, this.blue);

  // Automatic color mapping based on speed
  factory RgbColor.fromSpeed(FanSpeed speed) {
    switch (speed) {
      case FanSpeed.slow:
        return const RgbColor(255, 0, 0); // Red
      case FanSpeed.medium:
        return const RgbColor(0, 0, 255); // Blue
      case FanSpeed.fast:
        return const RgbColor(0, 255, 0); // Green
    }
  }

  // Parse from API string format "R,G,B"
  factory RgbColor.fromApiString(String colorString) {
    final parts = colorString.split(',').map((e) => int.tryParse(e.trim()) ?? 0).toList();
    if (parts.length != 3) {
      return const RgbColor(0, 0, 0);
    }
    return RgbColor(parts[0], parts[1], parts[2]);
  }

  // Convert to API string format "R,G,B"
  String toApiString() {
    return '$red,$green,$blue';
  }

  // Convert to Flutter Color for UI display
  Color toColor() {
    return Color.fromARGB(255, red, green, blue);
  }

  @override
  String toString() => 'RGB($red, $green, $blue)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RgbColor &&
          runtimeType == other.runtimeType &&
          red == other.red &&
          green == other.green &&
          blue == other.blue;

  @override
  int get hashCode => red.hashCode ^ green.hashCode ^ blue.hashCode;
}
