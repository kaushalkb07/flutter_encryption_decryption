// lib/features/chat/data/repositories/chat_repository_impl.dart

import 'dart:convert';
import 'package:cryptography/cryptography.dart';
import '../../domain/repositories/chat_repository.dart';

class ChatRepositoryImpl implements ChatRepository {
  final algorithm = AesGcm.with256bits();

  @override
  Future<String> encrypt(String message, List<int> sharedSecret) async {
    final secretKey = SecretKey(sharedSecret);
    final nonce = algorithm.newNonce();
    final secretBox = await algorithm.encrypt(
      utf8.encode(message),
      secretKey: secretKey,
      nonce: nonce,
    );
    return base64Encode(nonce + secretBox.cipherText + secretBox.mac.bytes);
  }

  @override
  Future<String> decrypt(String encryptedBase64, List<int> sharedSecret) async {
    final bytes = base64Decode(encryptedBase64);
    final nonce = bytes.sublist(0, 12);
    final cipherText = bytes.sublist(12, bytes.length - 16);
    final mac = Mac(bytes.sublist(bytes.length - 16));
    final secretKey = SecretKey(sharedSecret);

    final decrypted = await algorithm.decrypt(
      SecretBox(cipherText, nonce: nonce, mac: mac),
      secretKey: secretKey,
    );
    return utf8.decode(decrypted);
  }
}
