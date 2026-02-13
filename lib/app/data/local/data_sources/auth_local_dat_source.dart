// lib/app/data/datasources/auth_local_datasource.dart
import 'package:uv_pos/app/data/data.dart';
import 'package:uv_pos/core/core.dart';

abstract class AuthLocalDataSource {
  /// Save token
  Future<void> saveToken(TokenModel token);

  /// Get token
  Future<TokenModel?> getToken();

  /// Delete token
  Future<void> deleteToken();

  /// Save user
  Future<void> saveUser(UserModel user);

  /// Get user
  Future<UserModel?> getUser();

  /// Delete user
  Future<void> deleteUser();

  /// Check if user is logged in
  Future<bool> isLoggedIn();
}
