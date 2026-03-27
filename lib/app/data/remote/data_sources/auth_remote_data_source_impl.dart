import 'package:future_pos/app/data/data.dart';
import 'package:future_pos/core/core.dart';

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  AuthRemoteDataSourceImpl({
    required ApiClient apiClient,
    required GoogleSignIn googleSignIn,
  })  : _apiClient = apiClient,
        _googleSignIn = googleSignIn;

  final ApiClient _apiClient;
  final GoogleSignIn _googleSignIn;

  @override
  Future<AuthResponseModel> signInWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _apiClient.post(
        ApiEndpoints.login,
        data: {
          'email': email,
          'password': password,
        },
      );

      if (response.statusCode == 200) {
        return AuthResponseModel.fromJson(
          response.data as Map<String, dynamic>,
        );
      }

      throw ServerException(
        'Failed to sign in',
        response.statusCode ?? 500,
      );
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw ServerException(e.toString(), 500);
    }
  }

  @override
  Future<AuthResponseModel> signUpWithEmail({
    required String email,
    required String password,
    String? displayName,
  }) async {
    try {
      final response = await _apiClient.post(
        ApiEndpoints.register,
        data: {
          'email': email,
          'password': password,
          if (displayName != null) 'display_name': displayName,
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return AuthResponseModel.fromJson(
          response.data as Map<String, dynamic>,
        );
      }

      throw ServerException(
        'Failed to sign up',
        response.statusCode ?? 500,
      );
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw ServerException(e.toString(), 500);
    }
  }
  //
  // @override
  // Future<AuthResponseModel> signInWithGoogle() async {
  //   try {
  //     // 1. Trigger Google Sign In
  //     final googleUser = await _googleSignIn.signIn();
  //     if (googleUser == null) {
  //       throw const AuthException('Google sign in cancelled');
  //     }
  //
  //     // 2. Get auth details
  //     final googleAuth = await googleUser.authentication;
  //
  //     // 3. Send to backend
  //     final response = await _apiClient.post(
  //       ApiEndpoints.googleAuth,
  //       data: {
  //         'id_token': googleAuth.idToken,
  //         'access_token': googleAuth.accessToken,
  //       },
  //     );
  //
  //     if (response.statusCode == 200) {
  //       return AuthResponseModel.fromJson(
  //         response.data as Map<String, dynamic>,
  //       );
  //     }
  //
  //     throw ServerException(
  //       'Failed to sign in with Google',
  //       response.statusCode ?? 500,
  //     );
  //   } on DioException catch (e) {
  //     throw _handleDioError(e);
  //   } catch (e) {
  //     throw AuthException(e.toString());
  //   }
  // }

  @override
  Future<void> sendPhoneOtp({required String phoneNumber}) async {
    try {
      final response = await _apiClient.post(
        ApiEndpoints.sendOtp,
        data: {'phone_number': phoneNumber},
      );

      if (response.statusCode != 200) {
        throw ServerException(
          'Failed to send OTP',
          response.statusCode ?? 500,
        );
      }
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw ServerException(e.toString(), 500);
    }
  }

  @override
  Future<AuthResponseModel> verifyPhoneOtp({
    required String phoneNumber,
    required String otp,
  }) async {
    try {
      final response = await _apiClient.post(
        ApiEndpoints.verifyOtp,
        data: {
          'phone_number': phoneNumber,
          'otp': otp,
        },
      );

      if (response.statusCode == 200) {
        return AuthResponseModel.fromJson(
          response.data as Map<String, dynamic>,
        );
      }

      throw ServerException(
        'Failed to verify OTP',
        response.statusCode ?? 500,
      );
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw ServerException(e.toString(), 500);
    }
  }

  @override
  Future<UserModel> getCurrentUser() async {
    try {
      final response = await _apiClient.get(ApiEndpoints.currentUser);

      if (response.statusCode == 200) {
        return UserModel.fromJson(response.data as Map<String, dynamic>);
      }

      throw ServerException(
        'Failed to get current user',
        response.statusCode ?? 500,
      );
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw ServerException(e.toString(), 500);
    }
  }

  @override
  Future<void> sendEmailVerification() async {
    try {
      final response = await _apiClient.post(ApiEndpoints.verifyEmail);

      if (response.statusCode != 200) {
        throw ServerException(
          'Failed to send verification email',
          response.statusCode ?? 500,
        );
      }
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw ServerException(e.toString(), 500);
    }
  }

  @override
  Future<void> verifyEmail({required String token}) async {
    try {
      final response = await _apiClient.post(
        ApiEndpoints.verifyEmail,
        data: {'token': token},
      );

      if (response.statusCode != 200) {
        throw ServerException(
          'Failed to verify email',
          response.statusCode ?? 500,
        );
      }
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw ServerException(e.toString(), 500);
    }
  }

  @override
  Future<void> forgotPassword({required String email}) async {
    try {
      final response = await _apiClient.post(
        ApiEndpoints.forgotPassword,
        data: {'email': email},
      );

      if (response.statusCode != 200) {
        throw ServerException(
          'Failed to send password reset email',
          response.statusCode ?? 500,
        );
      }
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw ServerException(e.toString(), 500);
    }
  }

  @override
  Future<void> resetPassword({
    required String token,
    required String newPassword,
  }) async {
    try {
      final response = await _apiClient.post(
        ApiEndpoints.resetPassword,
        data: {
          'token': token,
          'new_password': newPassword,
        },
      );

      if (response.statusCode != 200) {
        throw ServerException(
          'Failed to reset password',
          response.statusCode ?? 500,
        );
      }
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw ServerException(e.toString(), 500);
    }
  }

  @override
  Future<UserModel> updateProfile({
    String? displayName,
    String? photoUrl,
  }) async {
    try {
      final response = await _apiClient.put(
        ApiEndpoints.updateProfile,
        data: {
          if (displayName != null) 'display_name': displayName,
          if (photoUrl != null) 'photo_url': photoUrl,
        },
      );

      if (response.statusCode == 200) {
        return UserModel.fromJson(response.data as Map<String, dynamic>);
      }

      throw ServerException(
        'Failed to update profile',
        response.statusCode ?? 500,
      );
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw ServerException(e.toString(), 500);
    }
  }

  @override
  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    try {
      final response = await _apiClient.post(
        '${ApiEndpoints.updateProfile}/change-password',
        data: {
          'current_password': currentPassword,
          'new_password': newPassword,
        },
      );

      if (response.statusCode != 200) {
        throw ServerException(
          'Failed to change password',
          response.statusCode ?? 500,
        );
      }
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw ServerException(e.toString(), 500);
    }
  }

  @override
  Future<TokenModel> refreshToken({required String refreshToken}) async {
    try {
      final response = await _apiClient.post(
        ApiEndpoints.refreshToken,
        data: {'refresh_token': refreshToken},
      );

      if (response.statusCode == 200) {
        return TokenModel.fromJson(response.data as Map<String, dynamic>);
      }

      throw ServerException(
        'Failed to refresh token',
        response.statusCode ?? 500,
      );
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw ServerException(e.toString(), 500);
    }
  }

  @override
  Future<void> logout() async {
    try {
      final response = await _apiClient.post(ApiEndpoints.logout);

      if (response.statusCode != 200) {
        throw ServerException(
          'Failed to logout',
          response.statusCode ?? 500,
        );
      }
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw ServerException(e.toString(), 500);
    }
  }

  @override
  Future<void> deleteAccount() async {
    try {
      final response = await _apiClient.delete(ApiEndpoints.deleteAccount);

      if (response.statusCode != 200) {
        throw ServerException(
          'Failed to delete account',
          response.statusCode ?? 500,
        );
      }
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw ServerException(e.toString(), 500);
    }
  }

  /// Handle Dio errors
  ServerException _handleDioError(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return const ServerException(
          'Connection timeout',
          408,
        );
      case DioExceptionType.badResponse:
        final statusCode = e.response?.statusCode ?? 500;
        final message =
            e.response?.data['message'] as String? ?? 'Server error occurred';
        return ServerException(message, statusCode);
      case DioExceptionType.cancel:
        return const ServerException(
          'Request cancelled',
          499,
        );
      default:
        return ServerException(
          e.message ?? 'Unknown error occurred',
          500,
        );
    }
  }
}
