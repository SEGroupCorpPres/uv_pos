// lib/app/data/repositories/auth_repository_impl.dart
import 'package:uv_pos/app/app_barrel.dart';
import 'package:uv_pos/core/core.dart';

/// Implementation of AuthRepository
class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl({
    required AuthRemoteDataSource remoteDataSource,
    required AuthLocalDataSource localDataSource,
  })  : _remoteDataSource = remoteDataSource,
        _localDataSource = localDataSource;

  final AuthRemoteDataSource _remoteDataSource;
  final AuthLocalDataSource _localDataSource;

  // Stream controller for auth state changes
  final _authStateController = StreamController<UserEntity?>.broadcast();

  @override
  ResultFuture<UserEntity?> getCurrentUser() async {
    try {
      // First check local cache
      final cachedUser = await _localDataSource.getUser();
      if (cachedUser != null && cachedUser.isNotEmpty) {
        return Right(cachedUser.toEntity());
      }

      // Check if token exists
      final token = await _localDataSource.getToken();
      if (token == null) {
        return const Right(null);
      }

      // Fetch from remote
      final user = await _remoteDataSource.getCurrentUser();

      // Update cache
      await _localDataSource.saveUser(user);

      return Right(user.toEntity());
    } on AuthException catch (e) {
      return Left(
        AuthFailure(
          e.message,
          e.code.toString(),
        ),
      );
    } on CacheException catch (e) {
      return Left(
        CacheFailure(
          e.message,
        ),
      );
    } on ServerException catch (e) {
      return Left(
        ServerFailure(
          e.message,
          e.code.toString(),
        ),
      );
    } catch (e) {
      return Left(
        AuthFailure(
          'Failed to get current user: $e',
          500.toString(),
        ),
      );
    }
  }

  @override
  ResultFuture<UserEntity> signInWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      // Call remote data source
      final authResponse = await _remoteDataSource.signInWithEmail(
        email: email,
        password: password,
      );

      // Save token to local storage
      await _localDataSource.saveToken(authResponse.token);

      // Save user to local storage
      await _localDataSource.saveUser(authResponse.user);

      // Emit auth state change
      _authStateController.add(authResponse.user.toEntity());

      return Right(authResponse.user.toEntity());
    } on AuthException catch (e) {
      return Left(
        AuthFailure(
          e.message,
          e.code.toString(),
        ),
      );
    } on NetworkException catch (e) {
      return Left(
        NetworkFailure(
          e.message,
          e.code.toString(),
        ),
      );
    } on ServerException catch (e) {
      return Left(
        ServerFailure(
          e.message,
          e.code.toString(),
        ),
      );
    } catch (e) {
      return Left(
        AuthFailure(
          'Sign in failed: $e',
          500.toString(),
        ),
      );
    }
  }

  @override
  ResultFuture<UserEntity> signUpWithEmail({
    required String email,
    required String password,
    String? displayName,
  }) async {
    try {
      // Call remote data source
      final authResponse = await _remoteDataSource.signUpWithEmail(
        email: email,
        password: password,
        displayName: displayName,
      );

      // Save token to local storage
      await _localDataSource.saveToken(authResponse.token);

      // Save user to local storage
      await _localDataSource.saveUser(authResponse.user);

      // Emit auth state change
      _authStateController.add(authResponse.user.toEntity());

      return Right(authResponse.user.toEntity());
    } on AuthException catch (e) {
      return Left(
        AuthFailure(
          e.message,
          e.code.toString(),
        ),
      );
    } on NetworkException catch (e) {
      return Left(
        NetworkFailure(
          e.message,
          e.code.toString(),
        ),
      );
    } on ServerException catch (e) {
      return Left(
        ServerFailure(
          e.message,
          e.code.toString(),
        ),
      );
    } catch (e) {
      return Left(
        AuthFailure(
          'Sign up failed: $e',
          500.toString(),
        ),
      );
    }
  }

  // @override
  // ResultFuture<UserEntity> signInWithGoogle() async {
  //   try {
  //     // Call remote data source
  //     final authResponse = await _remoteDataSource.signInWithGoogle();
  //
  //     // Save token to local storage
  //     await _localDataSource.saveToken(authResponse.token);
  //
  //     // Save user to local storage
  //     await _localDataSource.saveUser(authResponse.user);
  //
  //     // Emit auth state change
  //     _authStateController.add(authResponse.user.toEntity());
  //
  //     return Right(authResponse.user.toEntity());
  //   } on AuthException catch (e) {
  //     return Left(
  //       AuthFailure(
  //         e.message,
  //         e.code.toString(),
  //       ),
  //     );
  //   } on NetworkException catch (e) {
  //     return Left(
  //       NetworkFailure(
  //         e.message,
  //         e.code.toString(),
  //       ),
  //     );
  //   } on ServerException catch (e) {
  //     return Left(
  //       ServerFailure(
  //         e.message,
  //         e.code.toString(),
  //       ),
  //     );
  //   } catch (e) {
  //     return Left(
  //       AuthFailure(
  //         'Google sign in failed: $e',
  //         500.toString(),
  //       ),
  //     );
  //   }
  // }

  @override
  ResultVoid sendPhoneOtp({required String phoneNumber}) async {
    try {
      await _remoteDataSource.sendPhoneOtp(phoneNumber: phoneNumber);
      return const Right(null);
    } on AuthException catch (e) {
      return Left(
        AuthFailure(
          e.message,
          e.code.toString(),
        ),
      );
    } on NetworkException catch (e) {
      return Left(
        NetworkFailure(
          e.message,
          e.code.toString(),
        ),
      );
    } on ServerException catch (e) {
      return Left(
        ServerFailure(
          e.message,
          e.code.toString(),
        ),
      );
    } catch (e) {
      return Left(
        AuthFailure(
          'Failed to send OTP: $e',
          500.toString(),
        ),
      );
    }
  }

  @override
  ResultFuture<UserEntity> verifyPhoneOtp({
    required String phoneNumber,
    required String otp,
  }) async {
    try {
      // Verify OTP with remote data source
      final authResponse = await _remoteDataSource.verifyPhoneOtp(
        phoneNumber: phoneNumber,
        otp: otp,
      );

      // Save token to local storage
      await _localDataSource.saveToken(authResponse.token);

      // Save user to local storage
      await _localDataSource.saveUser(authResponse.user);

      // Emit auth state change
      _authStateController.add(authResponse.user.toEntity());

      return Right(authResponse.user.toEntity());
    } on AuthException catch (e) {
      return Left(
        AuthFailure(
          e.message,
          e.code.toString(),
        ),
      );
    } on NetworkException catch (e) {
      return Left(
        NetworkFailure(
          e.message,
          e.code.toString(),
        ),
      );
    } on ServerException catch (e) {
      return Left(
        ServerFailure(
          e.message,
          e.code.toString(),
        ),
      );
    } catch (e) {
      return Left(
        AuthFailure(
          'OTP verification failed: $e',
          500.toString(),
        ),
      );
    }
  }

  @override
  ResultVoid sendEmailVerification() async {
    try {
      await _remoteDataSource.sendEmailVerification();
      return const Right(null);
    } on AuthException catch (e) {
      return Left(
        AuthFailure(
          e.message,
          e.code.toString(),
        ),
      );
    } on NetworkException catch (e) {
      return Left(
        NetworkFailure(
          e.message,
          e.code.toString(),
        ),
      );
    } on ServerException catch (e) {
      return Left(
        ServerFailure(
          e.message,
          e.code.toString(),
        ),
      );
    } catch (e) {
      return Left(
        AuthFailure(
          'Failed to send verification email: $e',
          500.toString(),
        ),
      );
    }
  }

  @override
  ResultVoid verifyEmail({required String token}) async {
    try {
      await _remoteDataSource.verifyEmail(token: token);

      // Refresh user data to get updated email_verified status
      final user = await _remoteDataSource.getCurrentUser();
      await _localDataSource.saveUser(user);
      _authStateController.add(user.toEntity());

      return const Right(null);
    } on AuthException catch (e) {
      return Left(
        AuthFailure(
          e.message,
          e.code.toString(),
        ),
      );
    } on NetworkException catch (e) {
      return Left(
        NetworkFailure(
          e.message,
          e.code.toString(),
        ),
      );
    } on ServerException catch (e) {
      return Left(
        ServerFailure(
          e.message,
          e.code.toString(),
        ),
      );
    } catch (e) {
      return Left(
        AuthFailure(
          'Email verification failed: $e',
          500.toString(),
        ),
      );
    }
  }

  @override
  ResultVoid forgotPassword({required String email}) async {
    try {
      await _remoteDataSource.forgotPassword(email: email);
      return const Right(null);
    } on AuthException catch (e) {
      return Left(
        AuthFailure(
          e.message,
          e.code.toString(),
        ),
      );
    } on NetworkException catch (e) {
      return Left(
        NetworkFailure(
          e.message,
          e.code.toString(),
        ),
      );
    } on ServerException catch (e) {
      return Left(
        ServerFailure(
          e.message,
          e.code.toString(),
        ),
      );
    } catch (e) {
      return Left(
        AuthFailure(
          'Failed to send password reset email: $e',
          500.toString(),
        ),
      );
    }
  }

  @override
  ResultVoid resetPassword({
    required String token,
    required String newPassword,
  }) async {
    try {
      await _remoteDataSource.resetPassword(
        token: token,
        newPassword: newPassword,
      );
      return const Right(null);
    } on AuthException catch (e) {
      return Left(
        AuthFailure(
          e.message,
          e.code.toString(),
        ),
      );
    } on NetworkException catch (e) {
      return Left(
        NetworkFailure(
          e.message,
          e.code.toString(),
        ),
      );
    } on ServerException catch (e) {
      return Left(
        ServerFailure(
          e.message,
          e.code.toString(),
        ),
      );
    } catch (e) {
      return Left(
        AuthFailure(
          'Password reset failed: $e',
          500.toString(),
        ),
      );
    }
  }

  @override
  ResultFuture<UserEntity> updateProfile({
    String? displayName,
    String? photoUrl,
  }) async {
    try {
      // Update profile on remote
      final updatedUser = await _remoteDataSource.updateProfile(
        displayName: displayName,
        photoUrl: photoUrl,
      );

      // Update local cache
      await _localDataSource.saveUser(updatedUser);

      // Emit auth state change
      _authStateController.add(updatedUser.toEntity());

      return Right(updatedUser.toEntity());
    } on AuthException catch (e) {
      return Left(
        AuthFailure(
          e.message,
          e.code.toString(),
        ),
      );
    } on NetworkException catch (e) {
      return Left(
        NetworkFailure(
          e.message,
          e.code.toString(),
        ),
      );
    } on ServerException catch (e) {
      return Left(
        ServerFailure(
          e.message,
          e.code.toString(),
        ),
      );
    } catch (e) {
      return Left(
        AuthFailure(
          'Profile update failed: $e',
          500.toString(),
        ),
      );
    }
  }

  @override
  ResultVoid changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    try {
      await _remoteDataSource.changePassword(
        currentPassword: currentPassword,
        newPassword: newPassword,
      );
      return const Right(null);
    } on AuthException catch (e) {
      return Left(
        AuthFailure(
          e.message,
          e.code.toString(),
        ),
      );
    } on NetworkException catch (e) {
      return Left(
        NetworkFailure(
          e.message,
          e.code.toString(),
        ),
      );
    } on ServerException catch (e) {
      return Left(
        ServerFailure(
          e.message,
          e.code.toString(),
        ),
      );
    } catch (e) {
      return Left(
        AuthFailure(
          'Password change failed: $e',
          500.toString(),
        ),
      );
    }
  }

  @override
  ResultVoid refreshToken() async {
    try {
      // Get current refresh token
      final currentToken = await _localDataSource.getToken();
      if (currentToken == null) {
        return Left(
          AuthFailure(
            'No refresh token found',
            401.toString(),
          ),
        );
      }

      // Refresh token on remote
      final newToken = await _remoteDataSource.refreshToken(
        refreshToken: currentToken.refreshToken,
      );

      // Save new token
      await _localDataSource.saveToken(newToken);

      return const Right(null);
    } on AuthException catch (e) {
      // If refresh fails, clear local data
      await _clearLocalData();
      return Left(
        AuthFailure(
          e.message,
          e.code.toString(),
        ),
      );
    } on CacheException catch (e) {
      return Left(
        CacheFailure(
          e.message,
        ),
      );
    } on NetworkException catch (e) {
      return Left(
        NetworkFailure(
          e.message,
          e.code.toString(),
        ),
      );
    } on ServerException catch (e) {
      await _clearLocalData();
      return Left(
        ServerFailure(
          e.message,
          e.code.toString(),
        ),
      );
    } catch (e) {
      await _clearLocalData();
      return Left(
        AuthFailure(
          'Token refresh failed: $e',
          500.toString(),
        ),
      );
    }
  }

  @override
  ResultVoid signOut() async {
    try {
      // Call remote logout
      try {
        await _remoteDataSource.logout();
      } catch (_) {
        // Ignore remote logout errors, still clear local data
      }

      // Clear local data
      await _clearLocalData();

      // Emit auth state change
      _authStateController.add(null);

      return const Right(null);
    } on CacheException catch (e) {
      return Left(
        CacheFailure(
          e.message,
        ),
      );
    } catch (e) {
      return Left(
        AuthFailure(
          'Sign out failed: $e',
          500.toString(),
        ),
      );
    }
  }

  @override
  ResultVoid deleteAccount() async {
    try {
      // Delete account on remote
      await _remoteDataSource.deleteAccount();

      // Clear local data
      await _clearLocalData();

      // Emit auth state change
      _authStateController.add(null);

      return const Right(null);
    } on AuthException catch (e) {
      return Left(
        AuthFailure(
          e.message,
          e.code.toString(),
        ),
      );
    } on NetworkException catch (e) {
      return Left(
        NetworkFailure(
          e.message,
          e.code.toString(),
        ),
      );
    } on ServerException catch (e) {
      return Left(
        ServerFailure(
          e.message,
          e.code.toString(),
        ),
      );
    } catch (e) {
      return Left(
        AuthFailure(
          'Account deletion failed: $e',
          500.toString(),
        ),
      );
    }
  }

  @override
  Future<bool> isAuthenticated() async {
    try {
      // Check if token exists in local storage
      final token = await _localDataSource.getToken();
      if (token == null) return false;

      // Check if user exists in local storage
      final isLoggedIn = await _localDataSource.isLoggedIn();
      return isLoggedIn;
    } catch (e) {
      return false;
    }
  }

  @override
  Stream<UserEntity?> get authStateChanges {
    return _authStateController.stream;
  }

  /// Helper method to clear all local data
  Future<void> _clearLocalData() async {
    await _localDataSource.deleteToken();
    await _localDataSource.deleteUser();
  }

  /// Dispose stream controller
  Future<void> dispose() async {
    await _authStateController.close();
  }
} // Check if
