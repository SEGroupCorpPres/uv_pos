import 'package:future_pos/app/data/data.dart';
import 'package:future_pos/core/core.dart';

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  AuthLocalDataSourceImpl({
    required FlutterSecureStorage secureStorage,
  }) : _secureStorage = secureStorage;

  final FlutterSecureStorage _secureStorage;

  static const String _accessTokenKey = PrefKeys.accessToken;
  static const String _refreshTokenKey = PrefKeys.refreshToken;
  static const String _userKey = PrefKeys.userData;
  static const String _isLoggedInKey = PrefKeys.isLoggedIn;

  @override
  Future<void> saveToken(TokenModel token) async {
    try {
      await _secureStorage.write(
        key: _accessTokenKey,
        value: token.accessToken,
      );
      await _secureStorage.write(
        key: _refreshTokenKey,
        value: token.refreshToken,
      );
    } catch (e) {
      throw CacheException('Failed to save token: $e');
    }
  }

  @override
  Future<TokenModel?> getToken() async {
    try {
      final accessToken = await _secureStorage.read(key: _accessTokenKey);
      final refreshToken = await _secureStorage.read(key: _refreshTokenKey);

      if (accessToken == null || refreshToken == null) return null;

      return TokenModel(
        accessToken: accessToken,
        refreshToken: refreshToken,
      );
    } catch (e) {
      throw CacheException('Failed to get token: $e');
    }
  }

  @override
  Future<void> deleteToken() async {
    try {
      await _secureStorage.delete(key: _accessTokenKey);
      await _secureStorage.delete(key: _refreshTokenKey);
    } catch (e) {
      throw CacheException('Failed to delete token: $e');
    }
  }

  @override
  Future<void> saveUser(UserModel user) async {
    try {
      // PrefHelper handles encryption and string conversion internally
      final userJson = jsonEncode(user.toJson());
      await PrefHelper.save(_userKey, userJson);
      await PrefHelper.save(
          _isLoggedInKey, 'true'); // Saved as string for PrefHelper parsing
    } catch (e) {
      throw CacheException('Failed to save user: $e');
    }
  }

  @override
  Future<UserModel?> getUser() async {
    try {
      final data = PrefHelper.get(_userKey);

      if (data == null) return null;

      // Since PrefHelper attempts jsonDecode internally:
      if (data is Map<String, dynamic>) {
        return UserModel.fromJson(data);
      }

      // If PrefHelper returned it as a raw string (parsing failed internally)
      if (data is String) {
        return UserModel.fromJson(jsonDecode(data) as Map<String, dynamic>);
      }

      return null;
    } catch (e) {
      throw CacheException('Failed to get user: $e');
    }
  }

  @override
  Future<void> deleteUser() async {
    try {
      await PrefHelper.remove(_userKey);
      await PrefHelper.save(_isLoggedInKey, 'false');
    } catch (e) {
      throw CacheException('Failed to delete user: $e');
    }
  }

  @override
  Future<bool> isLoggedIn() async {
    final loggedIn = PrefHelper.get(_isLoggedInKey);
    return loggedIn ==
        true; // PrefHelper parses 'true' string to bool automatically
  }
}
