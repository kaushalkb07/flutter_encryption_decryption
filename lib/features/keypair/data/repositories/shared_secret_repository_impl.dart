import 'package:cryptography/cryptography.dart';
import '../../domain/repositories/shared_secret_repository.dart';

class SharedSecretRepositoryImpl implements SharedSecretRepository {
  final X25519 _algorithm = X25519();

  @override
  Future<List<int>> generateSharedSecret({
    required List<int> myPrivateKey,
    required List<int> otherPublicKey,
  }) async {
    // Create a SimpleKeyPair from the private key
    final keyPair = await _algorithm.newKeyPairFromSeed(myPrivateKey);

    // Extract public key bytes from the key pair
    final publicKeyBytes = await keyPair.extractPublicKey();

    // Create SimpleKeyPairData with both private and public key bytes
    final privateKey = SimpleKeyPairData(
      myPrivateKey,
      publicKey: publicKeyBytes, // Provide the public key
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
