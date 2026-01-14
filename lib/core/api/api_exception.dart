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
      'Délai de connexion ESP32 dépassé. Vérifiez que l\'appareil est allumé et connecté au WiFi.',
      ApiExceptionType.timeout,
    );
  }

  static ApiException networkError(dynamic error) {
    return ApiException(
      'Impossible de joindre l\'ESP32. Vérifiez l\'adresse IP et la connexion réseau.',
      ApiExceptionType.networkError,
      error,
    );
  }

  static ApiException invalidJson(dynamic error) {
    return ApiException(
      'Réponse invalide de l\'ESP32. L\'appareil peut être défectueux.',
      ApiExceptionType.invalidResponse,
      error,
    );
  }

  static ApiException notFound(String endpoint) {
    return ApiException(
      'Point de terminaison introuvable : $endpoint. Vérifiez la version du firmware ESP32.',
      ApiExceptionType.notFound,
    );
  }

  static ApiException serverError(int statusCode, String? body) {
    return ApiException(
      'Erreur ESP32 (HTTP $statusCode) : ${body ?? "Erreur inconnue"}',
      ApiExceptionType.serverError,
    );
  }

  static ApiException unknown(dynamic error) {
    return ApiException(
      'Erreur inattendue : ${error.toString()}',
      ApiExceptionType.unknown,
      error,
    );
  }
}
