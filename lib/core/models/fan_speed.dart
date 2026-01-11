enum FanSpeed {
  slow,
  medium,
  fast;

  String get displayName {
    switch (this) {
      case FanSpeed.slow:
        return 'Lent';
      case FanSpeed.medium:
        return 'Moyen';
      case FanSpeed.fast:
        return 'Rapide';
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
