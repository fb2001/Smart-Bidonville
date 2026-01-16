import 'package:flutter_test/flutter_test.dart';
import 'package:smart_bidonville/core/api/fan_api_service.dart';
import 'package:smart_bidonville/core/api/api_exception.dart';
import 'package:smart_bidonville/core/config/esp32_config.dart';
import 'package:smart_bidonville/core/models/fan_status.dart';
import 'package:smart_bidonville/core/models/fan_mode.dart';
import 'package:smart_bidonville/core/models/fan_speed.dart';
import 'package:smart_bidonville/core/models/rgb_color.dart';
import 'package:smart_bidonville/core/models/device_credentials.dart';
import 'package:smart_bidonville/features/dashboard/viewmodel/dashboard_provider.dart';
import 'package:smart_bidonville/features/dashboard/viewmodel/dashboard_state.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

// Simple fake client for testing
class FakeHttpClient extends http.BaseClient {
  final Map<String, dynamic> Function(String)? responseGenerator;
  final bool shouldThrow;

  FakeHttpClient({this.responseGenerator, this.shouldThrow = false});

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    if (shouldThrow) {
      throw http.ClientException('Network error');
    }

    final json = responseGenerator?.call(request.url.path) ?? {
      'temperature': 22.0,
      'speed': '',
      'mode': 'manual',
      'color': '0,0,0'
    };

    return http.StreamedResponse(
      Stream.value(utf8.encode(jsonEncode(json))),
      200,
      request: request,
    );
  }
}

// Fake config that doesn't use SharedPreferences
class FakeEsp32Config implements Esp32Config {
  String? _ip;
  String? _token;

  @override
  Future<String?> getIpAddress() async => _ip;

  @override
  Future<String?> getAuthToken() async => _token;

  @override
  Future<void> setIpAddress(String ip, {String? token}) async {
    _ip = ip;
    _token = token;
  }

  @override
  Future<void> setCredentials(DeviceCredentials credentials) async {
    _ip = credentials.ipAddress;
    _token = credentials.authToken;
  }

  @override
  Future<DeviceCredentials?> getCredentials() async {
    if (_ip == null) return null;
    return DeviceCredentials(
      ipAddress: _ip!,
      authToken: _token ?? '',
      deviceName: 'Test Device',
    );
  }

  @override
  Future<bool> isConfigured() async => _ip != null;

  @override
  Future<bool> hasAuthToken() async => _token != null && _token!.isNotEmpty;

  @override
  Future<void> clearIpAddress() async {
    _ip = null;
  }

  @override
  Future<void> clearCredentials() async {
    _ip = null;
    _token = null;
  }

  @override
  String getBaseUrl(String ip) => 'http://$ip';

  @override
  Duration get timeout => const Duration(seconds: 5);
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Dashboard Provider Tests', () {
    test('etat_initial_correct', () {
      final provider = DashboardProvider(enablePolling: false);
      expect(provider.state.status, DashboardStatus.initial);
      provider.dispose();
    });

    test('chargement_donnees_succes', () async {
      final fakeClient = FakeHttpClient(
        responseGenerator: (path) => {
          'temperature': 22.5,
          'speed': 'medium',
          'mode': 'auto',
          'color': '0,0,255'
        },
      );

      final config = FakeEsp32Config();
      final apiService = FanApiService(client: fakeClient, config: config);
      final provider = DashboardProvider(
        apiService: apiService,
        config: config,
        enablePolling: false,
      );

      await provider.setIpAddress('192.168.1.100');

      expect(provider.state.status, DashboardStatus.loaded);
      expect(provider.state.fanStatus?.temperature, 22.5);
      expect(provider.state.fanStatus?.speed, FanSpeed.medium);

      provider.dispose();
    }, timeout: Timeout(Duration(seconds: 5)));

    test('gestion_erreur_reseau', () async {
      final fakeClient = FakeHttpClient(shouldThrow: true);
      final config = FakeEsp32Config();
      final apiService = FanApiService(client: fakeClient, config: config);
      final provider = DashboardProvider(
        apiService: apiService,
        config: config,
        enablePolling: false,
      );

      await provider.setIpAddress('192.168.1.100');

      expect(provider.state.status, DashboardStatus.error);
      expect(provider.state.errorMessage, isNotNull);

      provider.dispose();
    }, timeout: Timeout(Duration(seconds: 5)));
  });
}
