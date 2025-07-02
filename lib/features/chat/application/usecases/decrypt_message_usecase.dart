import 'package:cryptography/cryptography.dart';

class DecryptMessageUseCase {
  final SecretKey secretKey;

  DecryptMessageUseCase(this.secretKey);

  Future<String> call(List<int> encrypted) async {
    final algorithm = AesGcm.with256bits();
    final nonce = encrypted.sublist(0, 12);
    final cipherText = encrypted.sublist(12, encrypted.length - 16);
    final mac = Mac(encrypted.sublist(encrypted.length - 16));

    final secretBox = SecretBox(cipherText, nonce: nonce, mac: mac);
    final clearText = await algorithm.decrypt(secretBox, secretKey: secretKey);
    return String.fromCharCodes(clearText);
  }
}
