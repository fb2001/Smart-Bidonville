import 'package:shared_preferences/shared_preferences.dart';

class Esp32Config {
  static const String _ipKey = 'esp32_ip_address';
  static const Duration _defaultTimeout = Duration(seconds: 3);

  // Singleton pattern
  static final Esp32Config _instance = Esp32Config._internal();
  factory Esp32Config() => _instance;
  Esp32Config._internal();

  String? _cachedIp;

  // Get stored IP address
  Future<String?> getIpAddress() async {
    if (_cachedIp != null) return _cachedIp;

    final prefs = await SharedPreferences.getInstance();
    _cachedIp = prefs.getString(_ipKey);
    return _cachedIp;
  }

  // Save IP address
  Future<void> setIpAddress(String ip) async {
    _cachedIp = ip;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_ipKey, ip);
  }

  // Check if IP is configured
  Future<bool> isConfigured() async {
    final ip = await getIpAddress();
    return ip != null && ip.isNotEmpty;
  }

  // Clear configuration (for testing/reset)
  Future<void> clearIpAddress() async {
    _cachedIp = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_ipKey);
  }

  // Build base URL for API calls
  String getBaseUrl(String ip) {
    return 'http://$ip';
  }

  Duration get timeout => _defaultTimeout;
}
