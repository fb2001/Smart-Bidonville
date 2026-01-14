import 'dart:convert';

/// Represents ESP32 device credentials scanned from QR code
class DeviceCredentials {
  final String ipAddress;
  final String authToken;
  final String? deviceName;

  DeviceCredentials({
    required this.ipAddress,
    required this.authToken,
    this.deviceName,
  });

  /// Parse credentials from QR code JSON
  /// Expected format: {"ip": "172.20.10.2", "token": "abc123xyz", "name": "Living Room Fan"}
  factory DeviceCredentials.fromQrCode(String qrData) {
    try {
      final json = jsonDecode(qrData) as Map<String, dynamic>;

      if (!json.containsKey('ip') || !json.containsKey('token')) {
        throw FormatException('QR code must contain "ip" and "token" fields');
      }

      return DeviceCredentials(
        ipAddress: json['ip'] as String,
        authToken: json['token'] as String,
        deviceName: json['name'] as String?,
      );
    } catch (e) {
      throw FormatException('Invalid QR code format: $e');
    }
  }

  /// Convert to JSON for storage
  Map<String, dynamic> toJson() {
    return {
      'ip': ipAddress,
      'token': authToken,
      if (deviceName != null) 'name': deviceName,
    };
  }

  /// Create from stored JSON
  factory DeviceCredentials.fromJson(Map<String, dynamic> json) {
    return DeviceCredentials(
      ipAddress: json['ip'] as String,
      authToken: json['token'] as String,
      deviceName: json['name'] as String?,
    );
  }

  @override
  String toString() {
    return 'DeviceCredentials(ip: $ipAddress, token: ${authToken.substring(0, 8)}..., name: $deviceName)';
  }
}
