import 'dart:async';
import 'package:flutter/foundation.dart';
import '../../../core/api/fan_api_service.dart';
import '../../../core/api/api_exception.dart';
import '../../../core/config/esp32_config.dart';
import '../../../core/models/device_credentials.dart';
import '../../../core/models/fan_mode.dart';
import '../../../core/models/fan_speed.dart';
import '../../../core/models/temperature_thresholds.dart';
import 'dashboard_state.dart';

class DashboardProvider extends ChangeNotifier {
  final FanApiService _apiService;
  final Esp32Config _config;
  final bool _enablePolling;

  DashboardState _state = DashboardState.initial();
  DashboardState get state => _state;

  Timer? _pollingTimer;
  static const _pollingInterval = Duration(seconds: 4);

  String? _currentIp;

  DashboardProvider({
    FanApiService? apiService,
    Esp32Config? config,
    bool enablePolling = true,
  })  : _apiService = apiService ?? FanApiService(),
        _config = config ?? Esp32Config(),
        _enablePolling = enablePolling;

  // === Initialization ===
  Future<void> initialize() async {
    _currentIp = await _config.getIpAddress();
    if (_currentIp != null) {
      await refreshData();
      startPolling();
    }
  }

  // === Polling Control ===
  void startPolling() {
    if (!_enablePolling) return;
    if (_pollingTimer?.isActive ?? false) return;

    _state = _state.copyWith(isPolling: true);
    notifyListeners();

    _pollingTimer = Timer.periodic(_pollingInterval, (_) {
      refreshData(silent: true); // Silent updates don't show loading
    });
  }

  void stopPolling() {
    _pollingTimer?.cancel();
    _pollingTimer = null;
    _state = _state.copyWith(isPolling: false);
    notifyListeners();
  }

  // === Data Fetching ===
  Future<void> refreshData({bool silent = false}) async {
    if (_currentIp == null) return;

    if (!silent) {
      _state = _state.copyWith(status: DashboardStatus.loading, clearError: true);
      notifyListeners();
    }

    try {
      final fanStatus = await _apiService.getFanStatus(_currentIp!);

      _state = _state.copyWith(
        status: DashboardStatus.loaded,
        fanStatus: fanStatus,
        clearError: true,
      );
      notifyListeners();
    } on ApiException catch (e) {
      _state = _state.copyWith(
        status: DashboardStatus.error,
        errorMessage: e.message,
      );
      notifyListeners();

      // Stop polling on persistent errors
      if (e.type == ApiExceptionType.networkError ||
          e.type == ApiExceptionType.timeout) {
        stopPolling();
      }
    }
  }

  // === Mode Control ===
  Future<bool> setMode(FanMode mode) async {
    if (_currentIp == null) return false;

    try {
      await _apiService.setMode(_currentIp!, mode);
      await refreshData(); // Refresh to get updated state
      return true;
    } on ApiException catch (e) {
      _state = _state.copyWith(
        status: DashboardStatus.error,
        errorMessage: e.message,
      );
      notifyListeners();
      return false;
    }
  }

  // === Manual Control ===
  Future<bool> setManualSpeed(FanSpeed speed) async {
    if (_currentIp == null) return false;

    try {
      await _apiService.setManualFan(_currentIp!, speed);
      await refreshData(); // Refresh to see changes
      return true;
    } on ApiException catch (e) {
      _state = _state.copyWith(
        status: DashboardStatus.error,
        errorMessage: e.message,
      );
      notifyListeners();
      return false;
    }
  }

  // === Threshold Control ===
  Future<bool> setThresholds(TemperatureThresholds thresholds) async {
    if (_currentIp == null) return false;

    if (!thresholds.isValid) {
      _state = _state.copyWith(
        status: DashboardStatus.error,
        errorMessage: thresholds.validationError,
      );
      notifyListeners();
      return false;
    }

    try {
      await _apiService.setThresholds(_currentIp!, thresholds);
      _state = _state.copyWith(thresholds: thresholds);
      notifyListeners();
      return true;
    } on ApiException catch (e) {
      _state = _state.copyWith(
        status: DashboardStatus.error,
        errorMessage: e.message,
      );
      notifyListeners();
      return false;
    }
  }

  // === IP Configuration ===
  Future<void> setIpAddress(String ip) async {
    await _config.setIpAddress(ip);
    _currentIp = ip;
    await refreshData();
    startPolling();
  }

  // === Credentials Configuration (with security token) ===
  Future<void> setCredentials(DeviceCredentials credentials) async {
    await _config.setCredentials(credentials);
    _currentIp = credentials.ipAddress;
    await refreshData();
    startPolling();
  }

  // === Error Handling ===
  void clearError() {
    _state = _state.copyWith(clearError: true);
    notifyListeners();
  }

  @override
  void dispose() {
    stopPolling();
    super.dispose();
  }
}
