// lib/app/data/datasources/auth_remote_datasource.dart
import 'package:uv_pos/app/app_barrel.dart';

abstract class AuthRemoteDataSource {
  /// Sign in with email
  Future<AuthResponseModel> signInWithEmail({
    required String email,
    required String password,
  });

  /// Sign up with email
  Future<AuthResponseModel> signUpWithEmail({
    required String email,
    required String password,
    String? displayName,
  });

  /// Sign in with Google
  // Future<AuthResponseModel> signInWithGoogle();

  /// Send OTP
  Future<void> sendPhoneOtp({required String phoneNumber});

  /// Verify OTP
  Future<AuthResponseModel> verifyPhoneOtp({
    required String phoneNumber,
    required String otp,
  });

  /// Get current user
  Future<UserModel> getCurrentUser();

  /// Send email verification
  Future<void> sendEmailVerification();

  /// Verify email
  Future<void> verifyEmail({required String token});

  /// Forgot password
  Future<void> forgotPassword({required String email});

  /// Reset password
  Future<void> resetPassword({
    required String token,
    required String newPassword,
  });

  /// Update profile
  Future<UserModel> updateProfile({
    String? displayName,
    String? photoUrl,
  });

  /// Change password
  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  });

  /// Refresh token
  Future<TokenModel> refreshToken({required String refreshToken});

  /// Logout
  Future<void> logout();

  /// Delete account
  Future<void> deleteAccount();
}
