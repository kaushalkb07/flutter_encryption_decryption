import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class KeyPairLocalStorage {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  Future<void> saveKeys({
    required String publicKey,
    required String privateKey,
  }) async {
    await _storage.write(key: 'publicKey', value: publicKey);
    await _storage.write(key: 'privateKey', value: privateKey);
  }

  Future<Map<String, String>?> getKeys() async {
    final publicKey = await _storage.read(key: 'publicKey');
    final privateKey = await _storage.read(key: 'privateKey');
    if (publicKey == null || privateKey == null) return null;
    return {'publicKey': publicKey, 'privateKey': privateKey};
  }

  Future<void> clearKeys() async {
    await _storage.delete(key: 'publicKey');
    await _storage.delete(key: 'privateKey');
  }
}
