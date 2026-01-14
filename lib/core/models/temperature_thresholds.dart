import 'fan_speed.dart';

class TemperatureThresholds {
  final double slow;
  final double medium;
  final double fast;

  const TemperatureThresholds({
    required this.slow,
    required this.medium,
    required this.fast,
  });

  // Default thresholds
  factory TemperatureThresholds.defaults() {
    return const TemperatureThresholds(
      slow: 22.0,
      medium: 26.0,
      fast: 30.0,
    );
  }

  // Parse from API response
  factory TemperatureThresholds.fromJson(Map<String, dynamic> json) {
    return TemperatureThresholds(
      slow: (json['slow'] as num?)?.toDouble() ?? 22.0,
      medium: (json['medium'] as num?)?.toDouble() ?? 26.0,
      fast: (json['fast'] as num?)?.toDouble() ?? 30.0,
    );
  }

  // Convert to API request
  Map<String, dynamic> toJson() {
    return {
      'slow': slow,
      'medium': medium,
      'fast': fast,
    };
  }

  // Validation: ensure slow < medium < fast
  bool get isValid => slow < medium && medium < fast;

  String get validationError {
    if (!isValid) {
      return 'Thresholds must satisfy: slow < medium < fast';
    }
    return '';
  }

  // Determine speed based on current temperature
  FanSpeed? speedForTemperature(double temperature) {
    if (temperature < slow) return null; // Fan off
    if (temperature < medium) return FanSpeed.slow;
    if (temperature < fast) return FanSpeed.medium;
    return FanSpeed.fast;
  }

  TemperatureThresholds copyWith({
    double? slow,
    double? medium,
    double? fast,
  }) {
    return TemperatureThresholds(
      slow: slow ?? this.slow,
      medium: medium ?? this.medium,
      fast: fast ?? this.fast,
    );
  }

  @override
  String toString() => 'Thresholds(slow: $slow°C, medium: $medium°C, fast: $fast°C)';
}
