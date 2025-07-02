import 'package:cryptography/cryptography.dart';
import '../../domain/repositories/shared_secret_repository.dart';

class SharedSecretRepositoryImpl implements SharedSecretRepository {
  final X25519 _algorithm = X25519();

  @override
  Future<List<int>> generateSharedSecret({
    required List<int> myPrivateKey,
    required List<int> myPublicKey,
    required List<int> otherPublicKey,
  }) async {
    final privateKey = SimpleKeyPairData(
      myPrivateKey,
      publicKey: SimplePublicKey(myPublicKey, type: KeyPairType.x25519),
      type: KeyPairType.x25519,
    );

    final publicKey = SimplePublicKey(
      otherPublicKey,
      type: KeyPairType.x25519,
    );

    final sharedSecretKey = await _algorithm.sharedSecretKey(
      keyPair: privateKey,
      remotePublicKey: publicKey,
    );

    return await sharedSecretKey.extractBytes();
  }
}
