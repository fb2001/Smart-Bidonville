import '../../../core/models/fan_status.dart';
import '../../../core/models/temperature_thresholds.dart';

enum DashboardStatus {
  initial,
  loading,
  loaded,
  error,
}

class DashboardState {
  final DashboardStatus status;
  final FanStatus? fanStatus;
  final TemperatureThresholds thresholds;
  final String? errorMessage;
  final bool isPolling;

  const DashboardState({
    required this.status,
    this.fanStatus,
    required this.thresholds,
    this.errorMessage,
    this.isPolling = false,
  });

  factory DashboardState.initial() {
    return DashboardState(
      status: DashboardStatus.initial,
      thresholds: TemperatureThresholds.defaults(),
    );
  }

  DashboardState copyWith({
    DashboardStatus? status,
    FanStatus? fanStatus,
    TemperatureThresholds? thresholds,
    String? errorMessage,
    bool? isPolling,
    bool clearError = false,
  }) {
    return DashboardState(
      status: status ?? this.status,
      fanStatus: fanStatus ?? this.fanStatus,
      thresholds: thresholds ?? this.thresholds,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      isPolling: isPolling ?? this.isPolling,
    );
  }

  bool get hasData => fanStatus != null;
  bool get hasError => status == DashboardStatus.error;
  bool get isLoading => status == DashboardStatus.loading;
}
