class ApiException implements Exception {
  final String message;
  final ApiExceptionType type;
  final dynamic originalError;

  ApiException(this.message, this.type, [this.originalError]);

  @override
  String toString() => message;
}

enum ApiExceptionType {
  timeout,
  networkError,
  invalidResponse,
  notFound,
  serverError,
  unknown,
}

class ApiExceptionFactory {
  static ApiException timeout() {
    return ApiException(
      'ESP32 connection timeout. Please check if the device is powered on and connected to WiFi.',
      ApiExceptionType.timeout,
    );
  }

  static ApiException networkError(dynamic error) {
    return ApiException(
      'Cannot reach ESP32. Verify IP address and network connection.',
      ApiExceptionType.networkError,
      error,
    );
  }

  static ApiException invalidJson(dynamic error) {
    return ApiException(
      'Invalid response from ESP32. The device may be malfunctioning.',
      ApiExceptionType.invalidResponse,
      error,
    );
  }

  static ApiException notFound(String endpoint) {
    return ApiException(
      'Endpoint not found: $endpoint. Please check ESP32 firmware version.',
      ApiExceptionType.notFound,
    );
  }

  static ApiException serverError(int statusCode, String? body) {
    return ApiException(
      'ESP32 error (HTTP $statusCode): ${body ?? "Unknown error"}',
      ApiExceptionType.serverError,
    );
  }

  static ApiException unknown(dynamic error) {
    return ApiException(
      'Unexpected error: ${error.toString()}',
      ApiExceptionType.unknown,
      error,
    );
  }
}
