import '../../domain/repositories/keypair_upload_repository.dart';

class UploadKeypairUseCase {
  final KeypairUploadRepository repository;

  UploadKeypairUseCase(this.repository);

  Future<void> call({
    required String userId,
    required List<int> publicKey,
    required List<int> privateKey,
  }) {
    return repository.uploadKeyPair(
      userId: userId,
      publicKey: publicKey,
      privateKey: privateKey,
    );
  }
}