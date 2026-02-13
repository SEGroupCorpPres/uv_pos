import 'package:uv_pos/core/core.dart';

sealed class PrefHelper {
  static late final SharedPreferences _pref;

  static Future<void> init() async {
    _pref = await SharedPreferences.getInstance();
  }

  static Future<bool> save(String key, String value) async {
    if (value.isEmpty) return false;
    final encryptedValue = AppEncryptor.encrypt(value);
    return _pref.setString(key, encryptedValue);
  }

  static dynamic get(String key, {bool getValueEncrypted = false}) {
    final encryptedValue = _pref.get(key) as String?;
    if (encryptedValue == null) return null;
    if (getValueEncrypted) return encryptedValue;

    final decryptedValue = AppEncryptor.decrypt(encryptedValue);

    /// Attempt to parse as bool
    if (decryptedValue == 'true' || decryptedValue == 'false') {
      return decryptedValue == 'true';
    }

    /// Attempt to parse as num
    final parsedNum = num.tryParse(decryptedValue);
    if (parsedNum != null) return parsedNum;

    /// Attempt to parse as a list (assuming a comma-separated string)
    if (decryptedValue.startsWith('[') && decryptedValue.endsWith(']')) {
      return decryptedValue
          .substring(1, decryptedValue.length - 1)
          .split(',')
          .map((e) => e.trim())
          .toList();
    }

    /// Attempt to parse as a map
    if (decryptedValue.startsWith('{') && decryptedValue.endsWith('}')) {
      try {
        return Map<String, dynamic>.from(jsonDecode(decryptedValue) as Map);
      } catch (_) {
        /// Return raw string if parsing fails
        return decryptedValue;
      }
    }

    /// Attempt to parse as DateTime
    final parsedDateTime = DateTime.tryParse(decryptedValue);
    if (parsedDateTime != null) return parsedDateTime;

    /// Return as plain string if no other parsing succeeds
    return decryptedValue;
  }

  static Future<bool> remove(String key) async {
    return _pref.remove(key);
  }

  static Future<bool> clear() async {
    return _pref.clear();
  }
}
