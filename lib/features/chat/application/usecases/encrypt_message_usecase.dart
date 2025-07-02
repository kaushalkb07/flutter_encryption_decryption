import 'package:cryptography/cryptography.dart';

class EncryptMessageUseCase {
  final SecretKey secretKey;

  EncryptMessageUseCase(this.secretKey);

  Future<List<int>> call(String message) async {
    final algorithm = AesGcm.with256bits();
    final nonce = algorithm.newNonce();
    final secretBox = await algorithm.encrypt(
      message.codeUnits,
      secretKey: secretKey,
      nonce: nonce,
    );
    return [...nonce, ...secretBox.cipherText, ...secretBox.mac.bytes];
  }
}
