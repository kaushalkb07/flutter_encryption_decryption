import '../../domain/repositories/keypair_upload_repository.dart';

class UploadKeypairUseCase {
  final KeypairUploadRepository repository;

  UploadKeypairUseCase(this.repository);

  Future<void> call({
    required String userId,
    required String deviceId,
    required List<int> publicKey,
    required List<int> privateKey,
  }) {
    return repository.uploadKeypair(
      userId: userId,
      deviceId: deviceId,
      publicKey: publicKey,
      privateKey: privateKey,
    );
  }
}
