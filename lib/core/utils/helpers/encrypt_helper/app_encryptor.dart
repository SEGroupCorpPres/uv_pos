import 'package:encrypt/encrypt.dart';
import 'package:future_pos/core/core.dart' hide Key;
import 'package:future_pos/core/utils/helpers/encrypt_helper/load_encrypt_key_and_iv.dart';

class AppEncryptor {
  static final _key = Key.fromBase64(LoadEncryptKeyAndIV.loadKey());
  static final _iv = IV.fromBase64(LoadEncryptKeyAndIV.loadIV());

  // AES algoritmi sozlamasi
  static final _encrypter = Encrypter(AES(_key, mode: AESMode.cbc));

  // Matnni shifrlash
  static String encrypt(String text) {
    if (text.isEmpty) return text;
    return _encrypter.encrypt(text, iv: _iv).base64;
  }

  // Shifrlangan matnni asliga qaytarish
  static String decrypt(String encryptedBase64) {
    if (encryptedBase64.isEmpty) return encryptedBase64;
    try {
      return _encrypter.decrypt64(encryptedBase64, iv: _iv);
    } catch (e) {
      return "Xatolik: Kalit noto'g'ri yoki ma'lumot buzilgan";
    }
  }
}
