import '../../domain/entities/keypair_entity.dart';
import '../../domain/repositories/keypair_repository.dart';

// Genereate Key Pair
class GenerateKeyPairUseCase {
  final KeyPairRepository repository;

  GenerateKeyPairUseCase(this.repository);

  Future<KeyPairEntity> call() {
    return repository.generateKeyPair();
  }
}


// Upload Public Key Pair
class UploadPublicKeyUseCase {
  final PublicKeyRepository repository;

  UploadPublicKeyUseCase(this.repository);

  Future<void> call(List<int> publicKey, String userId) {
    return repository.uploadPublicKey(publicKey, userId);
  }
}