import 'package:cryptography/cryptography.dart';
import '../../domain/repositories/shared_secret_repository.dart';

class SharedSecretRepositoryImpl implements SharedSecretRepository {
  final X25519 _algorithm = X25519();

  @override
  Future<List<int>> generateSharedSecret({
    required List<int> myPrivateKey,
    required List<int> otherPublicKey,
  }) async {
    try {
      // Validate key lengths (X25519 requires 32 bytes for both private and public keys)
      if (myPrivateKey.length != 32) {
        throw ArgumentError('Private key must be 32 bytes, got ${myPrivateKey.length}');
      }
      if (otherPublicKey.length != 32) {
        throw ArgumentError('Public key must be 32 bytes, got ${otherPublicKey.length}');
      }

      // Create a SimpleKeyPairData from raw private key bytes
      final privateKey = SimpleKeyPairData(
        myPrivateKey,
        type: KeyPairType.x25519,
      );

      // Create a SimplePublicKey from raw public key bytes
      final publicKey = SimplePublicKey(
        otherPublicKey,
        type: KeyPairType.x25519,
      );

      // Generate the shared secret key using ECDH
      final sharedSecretKey = await _algorithm.sharedSecretKey(
        keyPair: privateKey,
        remotePublicKey: publicKey, // Correct parameter name for cryptography 2.7.0
      );

      // Extract raw bytes of the shared secret
      final sharedSecretBytes = await sharedSecretKey.extractBytes();

      return sharedSecretBytes;
    } catch (e, stackTrace) {
      throw Exception('Failed to generate shared secret: $e\nStack trace: $stackTrace');
    }
  }
}