import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class KeyPairLocalStorage {
  final _storage = const FlutterSecureStorage();

  Future<void> save(String key, String value) async {
    await _storage.write(key: key, value: value);
  }

  Future<String?> read(String key) async {
    return await _storage.read(key: key);
  }

  // ✅ Add this method to retrieve both keys
  Future<Map<String, String>?> getKeys() async {
    final publicKey = await _storage.read(key: 'publicKey');
    final privateKey = await _storage.read(key: 'privateKey');

    if (publicKey != null && privateKey != null) {
      return {
        'publicKey': publicKey,
        'privateKey': privateKey,
      };
    }
    return null;
  }
}
