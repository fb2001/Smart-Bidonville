import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/fan_mode.dart';
import '../models/fan_speed.dart';
import '../models/fan_status.dart';
import '../models/temperature_thresholds.dart';
import '../models/rgb_color.dart';
import '../config/esp32_config.dart';
import 'api_exception.dart';

class FanApiService {
  final Esp32Config _config;
  final http.Client _client;

  FanApiService({Esp32Config? config, http.Client? client})
      : _config = config ?? Esp32Config(),
        _client = client ?? http.Client();

  // === GET /mode ===
  Future<FanMode> getMode(String ip) async {
    try {
      final url = Uri.parse('${_config.getBaseUrl(ip)}/mode');
      final response = await _client
          .get(url)
          .timeout(_config.timeout);

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        return FanMode.fromString(json['mode'] as String);
      } else if (response.statusCode == 404) {
        throw ApiExceptionFactory.notFound('/mode');
      } else {
        throw ApiExceptionFactory.serverError(response.statusCode, response.body);
      }
    } on TimeoutException {
      throw ApiExceptionFactory.timeout();
    } on http.ClientException catch (e) {
      throw ApiExceptionFactory.networkError(e);
    } on FormatException catch (e) {
      throw ApiExceptionFactory.invalidJson(e);
    } catch (e) {
      throw ApiExceptionFactory.unknown(e);
    }
  }

  // === PUT /mode ===
  Future<FanMode> setMode(String ip, FanMode mode) async {
    try {
      final url = Uri.parse('${_config.getBaseUrl(ip)}/mode');
      final response = await _client
          .put(
            url,
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({'mode': mode.toApiString()}),
          )
          .timeout(_config.timeout);

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        return FanMode.fromString(json['mode'] as String);
      } else {
        throw ApiExceptionFactory.serverError(response.statusCode, response.body);
      }
    } on TimeoutException {
      throw ApiExceptionFactory.timeout();
    } on http.ClientException catch (e) {
      throw ApiExceptionFactory.networkError(e);
    } on FormatException catch (e) {
      throw ApiExceptionFactory.invalidJson(e);
    } catch (e) {
      throw ApiExceptionFactory.unknown(e);
    }
  }

  // === GET /fan/status ===
  Future<FanStatus> getFanStatus(String ip) async {
    try {
      final url = Uri.parse('${_config.getBaseUrl(ip)}/fan/status');
      final response = await _client
          .get(url)
          .timeout(_config.timeout);

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        return FanStatus.fromJson(json);
      } else if (response.statusCode == 404) {
        throw ApiExceptionFactory.notFound('/fan/status');
      } else {
        throw ApiExceptionFactory.serverError(response.statusCode, response.body);
      }
    } on TimeoutException {
      throw ApiExceptionFactory.timeout();
    } on http.ClientException catch (e) {
      throw ApiExceptionFactory.networkError(e);
    } on FormatException catch (e) {
      throw ApiExceptionFactory.invalidJson(e);
    } catch (e) {
      throw ApiExceptionFactory.unknown(e);
    }
  }

  // === PUT /fan/manual ===
  Future<void> setManualFan(String ip, FanSpeed speed) async {
    try {
      final color = RgbColor.fromSpeed(speed); // Automatic color mapping
      final url = Uri.parse('${_config.getBaseUrl(ip)}/fan/manual');
      final response = await _client
          .put(
            url,
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({
              'speed': speed.toApiString(),
              'color': color.toApiString(),
            }),
          )
          .timeout(_config.timeout);

      if (response.statusCode != 200) {
        throw ApiExceptionFactory.serverError(response.statusCode, response.body);
      }
    } on TimeoutException {
      throw ApiExceptionFactory.timeout();
    } on http.ClientException catch (e) {
      throw ApiExceptionFactory.networkError(e);
    } catch (e) {
      throw ApiExceptionFactory.unknown(e);
    }
  }

  // === PUT /fan/threshold ===
  Future<void> setThresholds(String ip, TemperatureThresholds thresholds) async {
    if (!thresholds.isValid) {
      throw ArgumentError(thresholds.validationError);
    }

    try {
      final url = Uri.parse('${_config.getBaseUrl(ip)}/fan/threshold');
      final response = await _client
          .put(
            url,
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode(thresholds.toJson()),
          )
          .timeout(_config.timeout);

      if (response.statusCode != 200) {
        throw ApiExceptionFactory.serverError(response.statusCode, response.body);
      }
    } on TimeoutException {
      throw ApiExceptionFactory.timeout();
    } on http.ClientException catch (e) {
      throw ApiExceptionFactory.networkError(e);
    } catch (e) {
      throw ApiExceptionFactory.unknown(e);
    }
  }

  // === GET /temperature ===
  Future<double> getTemperature(String ip) async {
    try {
      final url = Uri.parse('${_config.getBaseUrl(ip)}/temperature');
      final response = await _client
          .get(url)
          .timeout(_config.timeout);

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        return (json['temperature'] as num).toDouble();
      } else if (response.statusCode == 404) {
        throw ApiExceptionFactory.notFound('/temperature');
      } else {
        throw ApiExceptionFactory.serverError(response.statusCode, response.body);
      }
    } on TimeoutException {
      throw ApiExceptionFactory.timeout();
    } on http.ClientException catch (e) {
      throw ApiExceptionFactory.networkError(e);
    } on FormatException catch (e) {
      throw ApiExceptionFactory.invalidJson(e);
    } catch (e) {
      throw ApiExceptionFactory.unknown(e);
    }
  }

  void dispose() {
    _client.close();
  }
}
