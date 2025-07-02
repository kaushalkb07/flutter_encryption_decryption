import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:uuid/uuid.dart';

class KeyPairLocalStorage {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  static const _publicKeyKey = 'public_key';
  static const _privateKeyKey = 'private_key';
  static const _deviceIdKey = 'device_id';

  Future<void> saveKeyPair({
    required List<int> publicKey,
    required List<int> privateKey,
  }) async {
    await _storage.write(key: _publicKeyKey, value: base64Encode(publicKey));
    await _storage.write(key: _privateKeyKey, value: base64Encode(privateKey));
  }

  Future<List<int>?> getPublicKey() async {
    final encoded = await _storage.read(key: _publicKeyKey);
    return encoded != null ? base64Decode(encoded) : null;
  }

  Future<List<int>?> getPrivateKey() async {
    final encoded = await _storage.read(key: _privateKeyKey);
    return encoded != null ? base64Decode(encoded) : null;
  }

  Future<String> getOrCreateDeviceId() async {
    final existing = await _storage.read(key: _deviceIdKey);
    if (existing != null) return existing;

    final uuid = const Uuid().v4();
    await _storage.write(key: _deviceIdKey, value: uuid);
    return uuid;
  }

  Future<void> clearAll() async {
    await _storage.deleteAll();
  }
}
