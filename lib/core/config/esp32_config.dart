import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/device_credentials.dart';

class Esp32Config {
  static const String _credentialsKey = 'esp32_credentials';
  static const Duration _defaultTimeout = Duration(seconds: 3);

  // Singleton pattern
  static final Esp32Config _instance = Esp32Config._internal();
  factory Esp32Config() => _instance;
  Esp32Config._internal();

  DeviceCredentials? _cachedCredentials;

  // Get stored credentials
  Future<DeviceCredentials?> getCredentials() async {
    if (_cachedCredentials != null) return _cachedCredentials;

    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_credentialsKey);

    if (jsonString != null) {
      try {
        final json = jsonDecode(jsonString) as Map<String, dynamic>;
        _cachedCredentials = DeviceCredentials.fromJson(json);
        return _cachedCredentials;
      } catch (e) {
        // Invalid stored data, clear it
        await clearCredentials();
        return null;
      }
    }

    return null;
  }

  // Get stored IP address (for backward compatibility)
  Future<String?> getIpAddress() async {
    final credentials = await getCredentials();
    return credentials?.ipAddress;
  }

  // Get stored auth token
  Future<String?> getAuthToken() async {
    final credentials = await getCredentials();
    return credentials?.authToken;
  }

  // Save credentials (from QR code scan)
  Future<void> setCredentials(DeviceCredentials credentials) async {
    _cachedCredentials = credentials;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_credentialsKey, jsonEncode(credentials.toJson()));
  }

  // Save IP address only (for backward compatibility without security)
  Future<void> setIpAddress(String ip, {String? token}) async {
    final credentials = DeviceCredentials(
      ipAddress: ip,
      authToken: token ?? '', // Empty token means no auth
    );
    await setCredentials(credentials);
  }

  // Check if device is configured
  Future<bool> isConfigured() async {
    final credentials = await getCredentials();
    return credentials != null && credentials.ipAddress.isNotEmpty;
  }

  // Check if authentication is enabled
  Future<bool> hasAuthToken() async {
    final credentials = await getCredentials();
    return credentials != null && credentials.authToken.isNotEmpty;
  }

  // Clear configuration (for testing/reset)
  Future<void> clearCredentials() async {
    _cachedCredentials = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_credentialsKey);
  }

  // Backward compatibility alias
  Future<void> clearIpAddress() async {
    await clearCredentials();
  }

  // Build base URL for API calls
  String getBaseUrl(String ip) {
    return 'http://$ip';
  }

  Duration get timeout => _defaultTimeout;
}
