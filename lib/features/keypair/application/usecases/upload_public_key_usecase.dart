import '../../domain/repositories/public_key_repository_impl.dart';

class UploadPublicKeyUseCase {
  final PublicKeyRepository repository;

  UploadPublicKeyUseCase(this.repository);

  Future<void> call(List<int> publicKey, String userId) {
    return repository.uploadPublicKey(publicKey, userId);
  }
}
