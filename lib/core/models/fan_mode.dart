enum FanMode {
  auto,
  manual;

  String get displayName {
    switch (this) {
      case FanMode.auto:
        return 'Automatique';
      case FanMode.manual:
        return 'Manuel';
    }
  }

  String toApiString() {
    return name; // 'auto', 'manual'
  }

  static FanMode fromString(String value) {
    return FanMode.values.firstWhere(
      (e) => e.name.toLowerCase() == value.toLowerCase(),
      orElse: () => FanMode.manual,
    );
  }

  bool get isAuto => this == FanMode.auto;
  bool get isManual => this == FanMode.manual;
}
