import '../../domain/repositories/shared_secret_repository.dart';

class GenerateSharedSecretUseCase {
  final SharedSecretRepository repository;

  GenerateSharedSecretUseCase(this.repository);

  Future<List<int>> call({
    required List<int> myPrivateKey,
    required List<int> otherPublicKey,
  }) async {
    return repository.generateSharedSecret(
      myPrivateKey: myPrivateKey,
      otherPublicKey: otherPublicKey,
    );
  }
}
