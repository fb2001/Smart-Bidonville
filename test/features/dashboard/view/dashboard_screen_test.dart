import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:smart_bidonville/features/dashboard/view/dashboard_screen.dart';
import 'package:smart_bidonville/features/dashboard/viewmodel/dashboard_provider.dart';
import 'package:smart_bidonville/features/dashboard/viewmodel/dashboard_state.dart';
import 'package:smart_bidonville/core/models/fan_status.dart';
import 'package:smart_bidonville/core/models/fan_mode.dart';
import 'package:smart_bidonville/core/models/fan_speed.dart';
import 'package:smart_bidonville/core/models/rgb_color.dart';
import 'package:smart_bidonville/core/api/fan_api_service.dart';
import 'package:smart_bidonville/core/config/esp32_config.dart';
import 'package:smart_bidonville/core/models/device_credentials.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class FakeHttpClient extends http.BaseClient {
  final Map<String, dynamic> Function(String)? responseGenerator;

  FakeHttpClient({this.responseGenerator});

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    final json = responseGenerator?.call(request.url.path) ?? {
      'temperature': 22.0,
      'speed': 'medium',
      'mode': 'auto',
      'color': '0,0,255'
    };

    return http.StreamedResponse(
      Stream.value(utf8.encode(jsonEncode(json))),
      200,
      request: request,
    );
  }
}

class FakeEsp32Config implements Esp32Config {
  String? _ip = '192.168.1.100';
  String? _token = 'test_token';

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
  Future<void> clearIpAddress() async => _ip = null;

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

Widget createTestWidget(Widget child) {
  return MaterialApp(
    home: child,
  );
}

void main() {
  test('placeholder_pour_tests_widget_futurs', () {
    expect(true, isTrue);
  });
}
