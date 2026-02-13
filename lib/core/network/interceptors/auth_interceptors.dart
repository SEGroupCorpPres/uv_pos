// lib/core/network/interceptors/auth_interceptor.dart
import 'package:uv_pos/core/core.dart';

/// Auth Interceptor - Handles authentication tokens
class AuthInterceptor extends Interceptor {
  AuthInterceptor({
    required FlutterSecureStorage secureStorage,
    Dio? dio,
  })  : _secureStorage = secureStorage,
        _dio = dio;

  final FlutterSecureStorage _secureStorage;
  final Dio? _dio;

  // Storage keys
  static const String _accessTokenKey = 'access_token';
  static const String _refreshTokenKey = 'refresh_token';

  // Endpoints that don't need authentication
  static const List<String> _publicEndpoints = [
    ApiEndpoints.login,
    ApiEndpoints.register,
    ApiEndpoints.forgotPassword,
    ApiEndpoints.resetPassword,
    ApiEndpoints.googleAuth,
    ApiEndpoints.sendOtp,
    ApiEndpoints.verifyOtp,
  ];

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    // Check if endpoint needs authentication
    if (_isPublicEndpoint(options.path)) {
      return handler.next(options);
    }

    try {
      // Get access token from secure storage
      final accessToken = await _getAccessToken();

      if (accessToken != null && accessToken.isNotEmpty) {
        // Add token to headers
        options.headers['Authorization'] = 'Bearer $accessToken';
      }

      handler.next(options);
    } catch (e) {
      handler.reject(
        DioException(
          requestOptions: options,
          error: 'Failed to add authentication token: $e',
        ),
      );
    }
  }

  @override
  Future<void> onError(DioException err, ErrorInterceptorHandler handler) async {
    // Handle 401 Unauthorized - Token expired or invalid
    if (err.response?.statusCode == 401) {
      try {
        // Try to refresh token
        final newToken = await _refreshAccessToken();

        if (newToken != null) {
          // Retry the failed request with new token
          final response = await _retryRequest(err.requestOptions, newToken);
          return handler.resolve(response);
        }

        // If refresh failed, clear tokens and reject
        await _clearTokens();
        return handler.reject(err);
      } catch (e) {
        // Refresh failed, clear tokens
        await _clearTokens();
        return handler.reject(err);
      }
    }

    // Pass other errors to next interceptor
    handler.next(err);
  }

  /// Get access token from secure storage
  Future<String?> _getAccessToken() async {
    try {
      return await _secureStorage.read(key: _accessTokenKey);
    } catch (e) {
      return null;
    }
  }

  /// Get refresh token from secure storage
  Future<String?> _getRefreshToken() async {
    try {
      return await _secureStorage.read(key: _refreshTokenKey);
    } catch (e) {
      return null;
    }
  }

  /// Save access token to secure storage
  Future<void> _saveAccessToken(String token) async {
    await _secureStorage.write(key: _accessTokenKey, value: token);
  }

  /// Clear all tokens
  Future<void> _clearTokens() async {
    await _secureStorage.delete(key: _accessTokenKey);
    await _secureStorage.delete(key: _refreshTokenKey);
  }

  /// Refresh access token using refresh token
  Future<String?> _refreshAccessToken() async {
    try {
      final refreshToken = await _getRefreshToken();
      if (refreshToken == null || refreshToken.isEmpty) {
        return null;
      }

      // Use separate Dio instance to avoid interceptor loop
      final dio = _dio ?? Dio();
      dio.options.baseUrl = ApiEndpoints.baseUrl;

      final response = await dio.post(
        ApiEndpoints.refreshToken,
        data: {'refresh_token': refreshToken},
      );

      if (response.statusCode == 200) {
        final data = response.data as Map<String, dynamic>;
        final newAccessToken = data['access_token'] as String?;
        final newRefreshToken = data['refresh_token'] as String?;

        if (newAccessToken != null) {
          // Save new tokens
          await _saveAccessToken(newAccessToken);
          if (newRefreshToken != null) {
            await _secureStorage.write(
              key: _refreshTokenKey,
              value: newRefreshToken,
            );
          }

          return newAccessToken;
        }
      }

      return null;
    } catch (e) {
      return null;
    }
  }

  /// Retry failed request with new token
  Future<Response> _retryRequest(
    RequestOptions requestOptions,
    String newToken,
  ) async {
    // Create new options with updated token
    final options = Options(
      method: requestOptions.method,
      headers: {
        ...requestOptions.headers,
        'Authorization': 'Bearer $newToken',
      },
    );

    // Use separate Dio instance to avoid interceptor loop
    final dio = _dio ?? Dio();
    dio.options.baseUrl = ApiEndpoints.baseUrl;

    return dio.request(
      requestOptions.path,
      data: requestOptions.data,
      queryParameters: requestOptions.queryParameters,
      options: options,
    );
  }

  /// Check if endpoint is public (doesn't need authentication)
  bool _isPublicEndpoint(String path) {
    return _publicEndpoints.any((endpoint) => path.contains(endpoint));
  }
}
