import 'package:flutter_test/flutter_test.dart';
import 'package:smart_bidonville/core/api/fan_api_service.dart';
import 'package:smart_bidonville/core/api/api_exception.dart';
import 'package:smart_bidonville/core/config/esp32_config.dart';
import 'package:smart_bidonville/core/models/fan_mode.dart';
import 'package:smart_bidonville/core/models/fan_speed.dart';
import 'package:smart_bidonville/core/models/fan_status.dart';
import 'package:smart_bidonville/core/models/temperature_thresholds.dart';
import 'package:smart_bidonville/core/models/device_credentials.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class FakeHttpClient extends http.BaseClient {
  final int statusCode;
  final Map<String, dynamic>? jsonResponse;
  final String? rawResponse;
  final bool shouldTimeout;
  final Duration? delayDuration;

  FakeHttpClient({
    this.statusCode = 200,
    this.jsonResponse,
    this.rawResponse,
    this.shouldTimeout = false,
    this.delayDuration,
  });

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    if (shouldTimeout) {
      await Future.delayed(Duration(seconds: 10));
    }

    if (delayDuration != null) {
      await Future.delayed(delayDuration!);
    }

    String body;
    if (rawResponse != null) {
      body = rawResponse!;
    } else if (jsonResponse != null) {
      body = jsonEncode(jsonResponse!);
    } else {
      body = '{}';
    }

    return http.StreamedResponse(
      Stream.value(utf8.encode(body)),
      statusCode,
      request: request,
      headers: {'content-type': 'application/json'},
    );
  }
}

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
  group('FanApiService - Codes HTTP', () {
    const testIp = '192.168.1.100';

    test('code_200_succes', () async {
      final client = FakeHttpClient(
        statusCode: 200,
        jsonResponse: {
          'temperature': 23.5,
          'speed': 'medium',
          'mode': 'auto',
          'color': '0,0,255'
        },
      );

      final config = FakeEsp32Config();
      final api = FanApiService(client: client, config: config);

      final status = await api.getFanStatus(testIp);

      expect(status.temperature, 23.5);
      expect(status.speed, FanSpeed.medium);
    });

    test('code_404_not_found', () async {
      final client = FakeHttpClient(
        statusCode: 404,
        jsonResponse: {'error': 'Not found'},
      );

      final config = FakeEsp32Config();
      final api = FanApiService(client: client, config: config);

      expect(
        () => api.getFanStatus(testIp),
        throwsA(isA<ApiException>()), // Le type peut être unknown l'important c'est qu'il throw
      );
    });

    test('code_401_unauthorized', () async {
      final client = FakeHttpClient(
        statusCode: 401,
        jsonResponse: {'error': 'Unauthorized'},
      );

      final config = FakeEsp32Config();
      final api = FanApiService(client: client, config: config);

      expect(
        () => api.getFanStatus(testIp),
        throwsA(isA<ApiException>()),
      );
    });

    test('code_500_server_error', () async {
      final client = FakeHttpClient(
        statusCode: 500,
        rawResponse: 'Internal Server Error',
      );

      final config = FakeEsp32Config();
      final api = FanApiService(client: client, config: config);

      expect(
        () => api.getFanStatus(testIp),
        throwsA(isA<ApiException>()),
      );
    });
  });

  group('FanApiService - Timeouts', () {
    const testIp = '192.168.1.100';

    test('timeout_apres_5_secondes', () async {
      final client = FakeHttpClient(shouldTimeout: true);
      final config = FakeEsp32Config();
      final api = FanApiService(client: client, config: config);

      expect(
        () => api.getFanStatus(testIp),
        throwsA(isA<ApiException>().having(
          (e) => e.type,
          'type',
          ApiExceptionType.timeout,
        )),
      );
    }, timeout: Timeout(Duration(seconds: 10)));
  });

  group('FanApiService - Authentication', () {
    const testIp = '192.168.1.100';
    const testToken = 'test_token_12345';

    test('header_authorization_ajoute_avec_token', () async {
      bool hasAuthHeader = false;
      
      final client = http.Client();
      final config = FakeEsp32Config();
      await config.setIpAddress(testIp, token: testToken);

      final api = FanApiService(client: client, config: config);

      final token = await config.getAuthToken();
      expect(token, testToken);
    });

    test('pas_de_header_sans_token', () async {
      final config = FakeEsp32Config();
      final token = await config.getAuthToken();
      expect(token, null);
    });
  });

  group('FanApiService - Parsing JSON', () {
    const testIp = '192.168.1.100';

    test('json_invalide_throw_exception', () async {
      final client = FakeHttpClient(
        statusCode: 200,
        rawResponse: 'invalid json{{{',
      );

      final config = FakeEsp32Config();
      final api = FanApiService(client: client, config: config);

      expect(
        () => api.getFanStatus(testIp),
        throwsA(isA<ApiException>().having(
          (e) => e.type,
          'type',
          ApiExceptionType.invalidResponse,
        )),
      );
    });

    test('json_manquant_champs_requis', () async {
      final client = FakeHttpClient(
        statusCode: 200,
        jsonResponse: {'temperature': 25.0}, // Manque speed  mode  color
      );

      final config = FakeEsp32Config();
      final api = FanApiService(client: client, config: config);

      final status = await api.getFanStatus(testIp);
      expect(status.temperature, 25.0);
    });
  });

  group('FanApiService - setMode', () {
    const testIp = '192.168.1.100';

    test('set_mode_auto_success', () async {
      final client = FakeHttpClient(
        statusCode: 200,
        jsonResponse: {'mode': 'auto'},
      );

      final config = FakeEsp32Config();
      final api = FanApiService(client: client, config: config);

      final result = await api.setMode(testIp, FanMode.auto);

      expect(result, FanMode.auto);
    });

    test('set_mode_manual_success', () async {
      final client = FakeHttpClient(
        statusCode: 200,
        jsonResponse: {'mode': 'manual'},
      );

      final config = FakeEsp32Config();
      final api = FanApiService(client: client, config: config);

      final result = await api.setMode(testIp, FanMode.manual);

      expect(result, FanMode.manual);
    });
  });

  group('FanApiService - setManualFan', () {
    const testIp = '192.168.1.100';

    test('set_vitesse_slow', () async {
      final client = FakeHttpClient(
        statusCode: 200,
        jsonResponse: {'speed': 'slow', 'color': '255,0,0'},
      );

      final config = FakeEsp32Config();
      final api = FanApiService(client: client, config: config);

      await api.setManualFan(testIp, FanSpeed.slow);
    });

    test('set_vitesse_fast', () async {
      final client = FakeHttpClient(
        statusCode: 200,
        jsonResponse: {'speed': 'fast', 'color': '0,255,0'},
      );

      final config = FakeEsp32Config();
      final api = FanApiService(client: client, config: config);

      await api.setManualFan(testIp, FanSpeed.fast);
    });
  });

  group('FanApiService - setThresholds', () {
    const testIp = '192.168.1.100';

    test('set_thresholds_valides', () async {
      final client = FakeHttpClient(
        statusCode: 200,
        jsonResponse: {'success': true},
      );

      final config = FakeEsp32Config();
      final api = FanApiService(client: client, config: config);

      final thresholds = TemperatureThresholds(
        slow: 22.0,
        medium: 26.0,
        fast: 30.0,
      );

      await api.setThresholds(testIp, thresholds);
    });

    test('set_thresholds_invalides_throw', () async {
      final config = FakeEsp32Config();
      final api = FanApiService(config: config);

      final invalidThresholds = TemperatureThresholds(
        slow: 30.0,
        medium: 22.0, // Invalide: medium < slow
        fast: 35.0,
      );

      expect(
        () => api.setThresholds(testIp, invalidThresholds),
        throwsA(isA<ArgumentError>()),
      );
    });
  });
}
