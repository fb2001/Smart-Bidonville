import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

/// A lightweight HTTP client wrapper that logs all outgoing requests and incoming responses.
///
/// - Redacts sensitive headers (e.g. Authorization).
/// - Logs are enabled by default in debug mode only.
class LoggingHttpClient extends http.BaseClient {
  final http.Client _inner;

  /// If false, no logs are emitted.
  final bool enabled;

  /// If true, sensitive headers like Authorization are redacted in logs.
  ///
  /// Can be overridden at build/run time with:
  /// `--dart-define=HTTP_LOG_REDACT_AUTH=false`
  final bool redactAuthorization;

  LoggingHttpClient({
    http.Client? inner,
    bool? enabled,
    bool? redactAuthorization,
  })  : _inner = inner ?? http.Client(),
        enabled = enabled ?? kDebugMode,
        redactAuthorization =
            redactAuthorization ?? const bool.fromEnvironment('HTTP_LOG_REDACT_AUTH', defaultValue: true);

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    if (!enabled) {
      return _inner.send(request);
    }

    final stopwatch = Stopwatch()..start();

    String? requestBodyPreview;
    if (request is http.Request) {
      requestBodyPreview = _safeBodyPreview(request.bodyBytes, request.headers['content-type']);
    }

    debugPrint(_formatRequestLog(request, requestBodyPreview));

    try {
      final response = await _inner.send(request);

      // Tee the stream so we can read and still return a usable response.
      final bytes = await response.stream.toBytes();
      final replayStream = Stream<List<int>>.fromIterable([bytes]);

      stopwatch.stop();

      final contentType = response.headers['content-type'];
      final responseBodyPreview = _safeBodyPreview(bytes, contentType);
      debugPrint(_formatResponseLog(request, response, stopwatch.elapsed, responseBodyPreview, bytes.length));

      return http.StreamedResponse(
        replayStream,
        response.statusCode,
        contentLength: response.contentLength,
        request: response.request,
        headers: response.headers,
        isRedirect: response.isRedirect,
        persistentConnection: response.persistentConnection,
        reasonPhrase: response.reasonPhrase,
      );
    } catch (e) {
      stopwatch.stop();
      debugPrint('[HTTP] ✗ ${request.method} ${request.url} (${stopwatch.elapsedMilliseconds}ms) error=$e');
      rethrow;
    }
  }

  @override
  void close() {
    _inner.close();
    super.close();
  }

  String _formatRequestLog(http.BaseRequest request, String? bodyPreview) {
    final headers = _redactHeaders(request.headers);

    final buffer = StringBuffer()
      ..writeln('[HTTP] → ${request.method} ${request.url}')
      ..writeln('[HTTP]   headers=${_jsonCompact(headers)}');

    if (bodyPreview != null && bodyPreview.isNotEmpty) {
      buffer.writeln('[HTTP]   body=$bodyPreview');
    }

    return buffer.toString().trimRight();
  }

  String _formatResponseLog(
    http.BaseRequest request,
    http.StreamedResponse response,
    Duration elapsed,
    String? bodyPreview,
    int byteLength,
  ) {
    final buffer = StringBuffer()
      ..writeln('[HTTP] ← ${request.method} ${request.url}')
      ..writeln('[HTTP]   status=${response.statusCode} time=${elapsed.inMilliseconds}ms bytes=$byteLength');

    if (bodyPreview != null && bodyPreview.isNotEmpty) {
      buffer.writeln('[HTTP]   body=$bodyPreview');
    }

    return buffer.toString().trimRight();
  }

  Map<String, String> _redactHeaders(Map<String, String> headers) {
    final result = <String, String>{};
    headers.forEach((key, value) {
      final lower = key.toLowerCase();
      if (lower == 'authorization') {
        if (redactAuthorization) {
          result[key] = 'Bearer **redacted**';
        } else {
          result[key] = value;
        }
      } else {
        result[key] = value;
      }
    });
    return result;
  }

  String _jsonCompact(Object value) {
    try {
      return jsonEncode(value);
    } catch (_) {
      return value.toString();
    }
  }

  String? _safeBodyPreview(List<int> bytes, String? contentType) {
    if (bytes.isEmpty) return null;

    // Avoid logging binary bodies.
    final ct = (contentType ?? '').toLowerCase();
    final looksText = ct.contains('json') || ct.contains('text') || ct.contains('application/x-www-form-urlencoded');
    if (!looksText) {
      return '<${bytes.length} bytes>';
    }

    String text;
    try {
      text = utf8.decode(bytes);
    } catch (_) {
      return '<${bytes.length} bytes (non-utf8)>';
    }

    // Keep logs readable.
    const maxLen = 2000;
    if (text.length > maxLen) {
      text = '${text.substring(0, maxLen)}…';
    }
    return text;
  }
}
