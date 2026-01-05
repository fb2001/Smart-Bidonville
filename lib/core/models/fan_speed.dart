enum FanSpeed {
  slow,
  medium,
  fast;

  String get displayName {
    switch (this) {
      case FanSpeed.slow:
        return 'Slow';
      case FanSpeed.medium:
        return 'Medium';
      case FanSpeed.fast:
        return 'Fast';
    }
  }

  String toApiString() {
    return name; // 'slow', 'medium', 'fast'
  }

  static FanSpeed fromString(String value) {
    return FanSpeed.values.firstWhere(
      (e) => e.name.toLowerCase() == value.toLowerCase(),
      orElse: () => FanSpeed.slow,
    );
  }
}
