// lib/features/keypair/data/datasources/keypair_local_storage.dart

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:uuid/uuid.dart'; // Make sure you add uuid package to pubspec.yaml
import 'dart:convert';

class KeyPairLocalStorage {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  static const _deviceIdKey = 'device_id';

  Future<void> saveKeys(List<int> publicKey, List<int> privateKey) async {
    await _storage.write(key: 'public_key', value: base64Encode(publicKey));
    await _storage.write(key: 'private_key', value: base64Encode(privateKey));
  }

  Future<List<int>?> getPublicKey() async {
    final encoded = await _storage.read(key: 'public_key');
    return encoded != null ? base64Decode(encoded) : null;
  }

  Future<List<int>?> getPrivateKey() async {
    final encoded = await _storage.read(key: 'private_key');
    return encoded != null ? base64Decode(encoded) : null;
  }

  /// ✅ Get the existing device ID or create a new one (UUID)
  Future<String> getOrCreateDeviceId() async {
    String? deviceId = await _storage.read(key: _deviceIdKey);

    if (deviceId == null) {
      final uuid = const Uuid().v4();
      await _storage.write(key: _deviceIdKey, value: uuid);
      deviceId = uuid;
    }

    return deviceId;
  }
}
