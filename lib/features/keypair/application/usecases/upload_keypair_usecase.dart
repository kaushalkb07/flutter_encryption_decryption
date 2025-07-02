import '../../domain/repositories/keypair_upload_repository.dart';

class UploadKeyPairUseCase {
  final KeyPairUploadRepository repository;

  UploadKeyPairUseCase(this.repository);

  Future<void> call({
    required String userId,
    required List<int> publicKey,
    required List<int> privateKey,
    required String authToken,
  }) async {
    await repository.uploadKeys(
      userId: userId,
      publicKey: publicKey,
      privateKey: privateKey,
      authToken: authToken,
    );
  }
}
