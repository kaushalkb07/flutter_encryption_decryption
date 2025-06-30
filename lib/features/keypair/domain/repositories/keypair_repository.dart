import '../entities/keypair_entity.dart';

// Generate Key (Privat and Public)
abstract class KeyPairRepository {
  Future<KeyPairEntity> generateKeyPair();
}

// Upload Public Key
abstract class PublicKeyRepository {
  Future<void> uploadPublicKey(List<int> publicKey, String userId);
}