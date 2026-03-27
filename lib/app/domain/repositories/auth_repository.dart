// lib/app/domain/repositories/auth_repository.dart
import 'package:future_pos/app/domain/entities/user_entity.dart';
import 'package:future_pos/core/core.dart';

/// Abstract authentication repository
abstract class AuthRepository {
  /// Get current user
  ResultFuture<UserEntity?> getCurrentUser();

  /// Sign in with email and password
  ResultFuture<UserEntity> signInWithEmail({
    required String email,
    required String password,
  });

  /// Sign up with email and password
  ResultFuture<UserEntity> signUpWithEmail({
    required String email,
    required String password,
    String? displayName,
  });

  /// Sign in with Google
  // ResultFuture<UserEntity> signInWithGoogle();

  /// Send OTP to phone
  ResultVoid sendPhoneOtp({required String phoneNumber});

  /// Verify phone OTP
  ResultFuture<UserEntity> verifyPhoneOtp({
    required String phoneNumber,
    required String otp,
  });

  /// Send email verification
  ResultVoid sendEmailVerification();

  /// Verify email with token
  ResultVoid verifyEmail({required String token});

  /// Forgot password
  ResultVoid forgotPassword({required String email});

  /// Reset password with token
  ResultVoid resetPassword({
    required String token,
    required String newPassword,
  });

  /// Update profile
  ResultFuture<UserEntity> updateProfile({
    String? displayName,
    String? photoUrl,
  });

  /// Change password
  ResultVoid changePassword({
    required String currentPassword,
    required String newPassword,
  });

  /// Refresh token
  ResultVoid refreshToken();

  /// Sign out
  ResultVoid signOut();

  /// Delete account
  ResultVoid deleteAccount();

  /// Check if user is authenticated
  Future<bool> isAuthenticated();

  /// Stream of auth state changes
  Stream<UserEntity?> get authStateChanges;
}
