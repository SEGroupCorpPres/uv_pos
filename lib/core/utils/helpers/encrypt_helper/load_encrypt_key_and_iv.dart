import 'package:uv_pos/core/core.dart' hide Key;

sealed class LoadEncryptKeyAndIV {
  static String loadKey() {
    final keyFromEnv = dotenv.get('ENCRYPT_KEY');
    print('Generated Key (Base64): ${keyFromEnv}');
    return keyFromEnv;
  }

  static String loadIV() {
    final ivFromEnv = dotenv.get('ENCRYPT_IV');
    print('Generated IV (Base64): ${ivFromEnv}');
    return ivFromEnv;
  }
}
