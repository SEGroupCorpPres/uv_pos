import 'package:uv_pos/core/core.dart' hide Key;

sealed class LoadEncryptKeyAndIV {
  static String loadKey() {
    final keyFromEnv = dotenv.get('ENCRYPT_KEY');
    logger.d('Generated Key (Base64): $keyFromEnv');
    return keyFromEnv;
  }

  static String loadIV() {
    final ivFromEnv = dotenv.get('ENCRYPT_IV');
    logger.d('Generated IV (Base64): $ivFromEnv');
    return ivFromEnv;
  }
}
