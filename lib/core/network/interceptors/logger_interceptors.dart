// lib/core/network/interceptors/logger_interceptor.dart
import 'dart:developer' as dev;

import 'package:uv_pos/core/core.dart';

/// Logger Interceptor - Logs requests and responses
class LoggerInterceptor extends Interceptor {
  LoggerInterceptor({
    this.request = true,
    this.requestHeader = true,
    this.requestBody = true,
    this.responseHeader = false,
    this.responseBody = true,
    this.error = true,
    this.logPrint = _defaultLogPrint,
  });

  /// Print request [Options]
  final bool request;

  /// Print request header [Options.headers]
  final bool requestHeader;

  /// Print request data [Options.data]
  final bool requestBody;

  /// Print [Response.headers]
  final bool responseHeader;

  /// Print [Response.data]
  final bool responseBody;

  /// Print error message
  final bool error;

  /// Log printer; defaults print log to console.
  final void Function(Object object) logPrint;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (request) {
      _logRequest(options);
    }
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    if (responseBody || responseHeader) {
      _logResponse(response);
    }
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (error) {
      _logError(err);
    }
    handler.next(err);
  }

  /// Log request details
  void _logRequest(RequestOptions options) {
    final buffer = StringBuffer()

      // Request header
      ..writeln('╔════════════════════════════════════════════════════════')
      ..writeln('║ 📤 REQUEST')
      ..writeln('╠════════════════════════════════════════════════════════')
      ..writeln('║ Method: ${options.method}')
      ..writeln('║ URL: ${options.uri}');

    // Request headers
    if (requestHeader && options.headers.isNotEmpty) {
      buffer
        ..writeln('╠──────────────────────────────────────────────────────')
        ..writeln('║ Headers:');
      options.headers.forEach((key, value) {
        // Hide sensitive data
        if (_isSensitiveHeader(key)) {
          buffer.writeln('║   $key: ***HIDDEN***');
        } else {
          buffer.writeln('║   $key: $value');
        }
      });
    }

    // Query parameters
    if (options.queryParameters.isNotEmpty) {
      buffer
        ..writeln('╠──────────────────────────────────────────────────────')
        ..writeln('║ Query Parameters:');
      options.queryParameters.forEach((key, value) {
        buffer.writeln('║   $key: $value');
      });
    }

    // Request body
    if (requestBody && options.data != null) {
      buffer
        ..writeln('╠──────────────────────────────────────────────────────')
        ..writeln('║ Body:');

      final data = options.data;
      if (data is Map) {
        _logMap(buffer, data);
      } else if (data is FormData) {
        buffer.writeln('║   FormData: ${data.fields.length} fields');
      } else {
        buffer.writeln('║   ${_formatData(data)}');
      }
    }

    buffer.writeln('╚════════════════════════════════════════════════════════');

    logPrint(buffer.toString());
  }

  /// Log response details
  void _logResponse(Response response) {
    final buffer = StringBuffer()

      // Response header
      ..writeln('╔════════════════════════════════════════════════════════')
      ..writeln('║ 📥 RESPONSE')
      ..writeln('╠════════════════════════════════════════════════════════')
      ..writeln('║ Status: ${response.statusCode} ${response.statusMessage}')
      ..writeln('║ URL: ${response.requestOptions.uri}');

    // Response headers
    if (responseHeader && response.headers.map.isNotEmpty) {
      buffer
        ..writeln('╠──────────────────────────────────────────────────────')
        ..writeln('║ Headers:');
      response.headers.map.forEach((key, value) {
        buffer.writeln('║   $key: ${value.join(', ')}');
      });
    }

    // Response body
    if (responseBody && response.data != null) {
      buffer
        ..writeln('╠──────────────────────────────────────────────────────')
        ..writeln('║ Body:');

      final data = response.data;
      if (data is Map) {
        _logMap(buffer, data);
      } else if (data is List) {
        buffer.writeln('║   Array[${data.length}]');
        if (data.isNotEmpty) {
          buffer.writeln('║   ${_formatData(data.first)}');
        }
      } else {
        buffer.writeln('║   ${_formatData(data)}');
      }
    }

    buffer.writeln('╚════════════════════════════════════════════════════════');

    logPrint(buffer.toString());
  }

  /// Log error details
  void _logError(DioException err) {
    final buffer = StringBuffer()

      // Error header
      ..writeln('╔════════════════════════════════════════════════════════')
      ..writeln('║ ❌ ERROR')
      ..writeln('╠════════════════════════════════════════════════════════')
      ..writeln('║ Type: ${err.type}')
      ..writeln('║ URL: ${err.requestOptions.uri}')
      ..writeln('║ Method: ${err.requestOptions.method}');

    // Error message
    if (err.message != null) {
      buffer
        ..writeln('╠──────────────────────────────────────────────────────')
        ..writeln('║ Message:')
        ..writeln('║   ${err.message}');
    }

    // Response error
    if (err.response != null) {
      buffer
        ..writeln('╠──────────────────────────────────────────────────────')
        ..writeln('║ Status: ${err.response!.statusCode}');

      if (err.response!.data != null) {
        buffer.writeln('║ Response:');
        final data = err.response!.data;
        if (data is Map) {
          _logMap(buffer, data);
        } else {
          buffer.writeln('║   ${_formatData(data)}');
        }
      }
    }

    // Stack trace (only in debug mode)
    if (kDebugMode && err.stackTrace != null) {
      buffer
        ..writeln('╠──────────────────────────────────────────────────────')
        ..writeln('║ Stack Trace:');
      final stackLines = err.stackTrace.toString().split('\n').take(5);
      for (final line in stackLines) {
        buffer.writeln('║   $line');
      }
    }

    buffer.writeln('╚════════════════════════════════════════════════════════');

    logPrint(buffer.toString());
  }

  /// Log map data with indentation
  void _logMap(StringBuffer buffer, Map map, {int indent = 1}) {
    final spaces = '  ' * indent;
    map.forEach((key, value) {
      // Hide sensitive data
      if (_isSensitiveKey(key.toString())) {
        buffer.writeln('║ $spaces$key: ***HIDDEN***');
      } else if (value is Map) {
        buffer.writeln('║ $spaces$key: {');
        _logMap(buffer, value, indent: indent + 1);
        buffer.writeln('║ $spaces}');
      } else if (value is List) {
        buffer.writeln('║ $spaces$key: Array[${value.length}]');
      } else {
        buffer.writeln('║ $spaces$key: ${_formatData(value)}');
      }
    });
  }

  /// Format data for logging
  String _formatData(dynamic data) {
    if (data == null) return 'null';

    final str = data.toString();
    const maxLength = 200;

    if (str.length > maxLength) {
      return '${str.substring(0, maxLength)}... (${str.length} chars)';
    }

    return str;
  }

  /// Check if header is sensitive
  bool _isSensitiveHeader(String key) {
    final lowerKey = key.toLowerCase();
    return lowerKey.contains('authorization') ||
        lowerKey.contains('token') ||
        lowerKey.contains('cookie') ||
        lowerKey.contains('api-key') ||
        lowerKey.contains('apikey');
  }

  /// Check if key is sensitive
  bool _isSensitiveKey(String key) {
    final lowerKey = key.toLowerCase();
    return lowerKey.contains('password') ||
        lowerKey.contains('token') ||
        lowerKey.contains('secret') ||
        lowerKey.contains('api_key') ||
        lowerKey.contains('apikey') ||
        lowerKey.contains('access_token') ||
        lowerKey.contains('refresh_token');
  }

  /// Default log print function
  static void _defaultLogPrint(Object object) {
    if (kDebugMode) {
      dev.log(object.toString(), name: 'DIO');
    }
  }
}
