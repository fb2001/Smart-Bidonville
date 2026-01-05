import 'fan_mode.dart';
import 'fan_speed.dart';
import 'rgb_color.dart';

class FanStatus {
  final FanMode mode;
  final FanSpeed? speed; // null when fan is off
  final RgbColor color;
  final double temperature;

  const FanStatus({
    required this.mode,
    this.speed,
    required this.color,
    required this.temperature,
  });

  // Parse from GET /fan/status response
  factory FanStatus.fromJson(Map<String, dynamic> json) {
    final speedStr = json['speed'] as String?;
    return FanStatus(
      mode: FanMode.fromString(json['mode'] as String? ?? 'manual'),
      speed: speedStr != null && speedStr.isNotEmpty
          ? FanSpeed.fromString(speedStr)
          : null,
      color: RgbColor.fromApiString(json['color'] as String? ?? '0,0,0'),
      temperature: (json['temperature'] as num?)?.toDouble() ?? 0.0,
    );
  }

  bool get isFanRunning => speed != null;

  FanStatus copyWith({
    FanMode? mode,
    FanSpeed? speed,
    RgbColor? color,
    double? temperature,
  }) {
    return FanStatus(
      mode: mode ?? this.mode,
      speed: speed,
      color: color ?? this.color,
      temperature: temperature ?? this.temperature,
    );
  }

  @override
  String toString() => 'FanStatus(mode: $mode, speed: $speed, color: $color, temp: $temperature°C)';
}
