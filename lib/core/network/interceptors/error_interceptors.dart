// lib/core/network/interceptors/error_interceptor.dart
import 'package:future_pos/core/core.dart';

/// Error Interceptor - Handles and maps errors
class ErrorInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final exception = _mapDioExceptionToAppException(err);

    // Create new DioException with mapped error
    final newError = DioException(
      requestOptions: err.requestOptions,
      response: err.response,
      type: err.type,
      error: exception,
      message: exception.message,
    );

    handler.next(newError);
  }

  /// Map DioException to AppException
  AppException _mapDioExceptionToAppException(DioException error) {
    switch (error.type) {
      // Connection timeout
      case DioExceptionType.connectionTimeout:
        return const NetworkException(
          'Connection timeout. Please check your internet connection.',
          408,
        );

      // Send timeout
      case DioExceptionType.sendTimeout:
        return const NetworkException(
          'Request timeout. Please try again.',
          408,
        );

      // Receive timeout
      case DioExceptionType.receiveTimeout:
        return const NetworkException(
          'Server is taking too long to respond. Please try again.',
          408,
        );

      // Bad response (4xx, 5xx errors)
      case DioExceptionType.badResponse:
        return _handleBadResponse(error);

      // Request cancelled
      case DioExceptionType.cancel:
        return const ServerException(
          'Request was cancelled',
          499,
        );

      // Connection error
      case DioExceptionType.connectionError:
        return _handleConnectionError(error);

      // Bad certificate
      case DioExceptionType.badCertificate:
        return const NetworkException(
          'Security certificate error. Please contact support.',
          495,
        );

      // Unknown error
      case DioExceptionType.unknown:
        return _handleUnknownError(error);
    }
  }

  /// Handle bad response errors (4xx, 5xx)
  AppException _handleBadResponse(DioException error) {
    final statusCode = error.response?.statusCode ?? 500;
    final data = error.response?.data;

    // Try to extract error message from response
    String message = 'An error occurred';
    if (data is Map<String, dynamic>) {
      message = data['message'] as String? ??
          data['error'] as String? ??
          data['detail'] as String? ??
          message;
    } else if (data is String) {
      message = data;
    }

    // Map status code to appropriate exception
    switch (statusCode) {
      // 400 - Bad Request
      case 400:
        return ServerException(
          message.isNotEmpty ? message : 'Invalid request',
          statusCode,
        );

      // 401 - Unauthorized
      case 401:
        return AuthException(
          message.isNotEmpty
              ? message
              : 'Authentication failed. Please login again.',
          statusCode,
        );

      // 403 - Forbidden
      case 403:
        return AuthException(
          message.isNotEmpty
              ? message
              : "Access denied. You don't have permission.",
          statusCode,
        );

      // 404 - Not Found
      case 404:
        return ServerException(
          message.isNotEmpty ? message : 'Resource not found',
          statusCode,
        );

      // 408 - Request Timeout
      case 408:
        return NetworkException(
          message.isNotEmpty ? message : 'Request timeout',
          statusCode,
        );

      // 409 - Conflict
      case 409:
        return ServerException(
          message.isNotEmpty ? message : 'Resource conflict',
          statusCode,
        );

      // 422 - Unprocessable Entity (Validation error)
      case 422:
        return ServerException(
          message.isNotEmpty ? message : 'Validation error',
          statusCode,
        );

      // 429 - Too Many Requests
      case 429:
        return ServerException(
          message.isNotEmpty
              ? message
              : 'Too many requests. Please try again later.',
          statusCode,
        );

      // 500 - Internal Server Error
      case 500:
        return ServerException(
          message.isNotEmpty
              ? message
              : 'Server error. Please try again later.',
          statusCode,
        );

      // 502 - Bad Gateway
      case 502:
        return NetworkException(
          message.isNotEmpty ? message : 'Server is temporarily unavailable',
          statusCode,
        );

      // 503 - Service Unavailable
      case 503:
        return NetworkException(
          message.isNotEmpty ? message : 'Service is temporarily unavailable',
          statusCode,
        );

      // 504 - Gateway Timeout
      case 504:
        return NetworkException(
          message.isNotEmpty ? message : 'Gateway timeout',
          statusCode,
        );

      // Other errors
      default:
        if (statusCode >= 500) {
          return ServerException(
            message.isNotEmpty ? message : 'Server error occurred',
            statusCode,
          );
        } else {
          return ServerException(
            message.isNotEmpty ? message : 'An error occurred',
            statusCode,
          );
        }
    }
  }

  /// Handle connection errors
  AppException _handleConnectionError(DioException error) {
    final originalError = error.error;

    if (originalError is SocketException) {
      return const NetworkException(
        'No internet connection. Please check your network.',
      );
    }

    if (originalError is HttpException) {
      return NetworkException(
        originalError.message,
      );
    }

    return const NetworkException(
      'Failed to connect to server. Please check your connection.',
    );
  }

  /// Handle unknown errors
  AppException _handleUnknownError(DioException error) {
    final originalError = error.error;

    // Check for specific error types
    if (originalError is SocketException) {
      return const NetworkException(
        'No internet connection',
      );
    }

    if (originalError is FormatException) {
      return const ServerException(
        'Invalid data format received from server',
        500,
      );
    }

    // Default unknown error
    return ServerException(
      error.message ?? 'An unexpected error occurred',
      500,
    );
  }
}
