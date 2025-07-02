// lib/features/keypair/application/usecases/upload_keypair_usecase.dart

import '../../domain/repositories/keypair_upload_repository.dart';

class UploadKeyPairUseCase {
  final KeyPairUploadRepository repository;

  UploadKeyPairUseCase(this.repository);

  Future<void> call({
    required String userId,
    required List<int> publicKey,
    required List<int> privateKey,
    required String token, // <-- make sure this is here
  }) async {
    await repository.uploadKeyPair(
      userId: userId,
      publicKey: publicKey,
      privateKey: privateKey,
      token: token, // <-- pass it here
    );
  }
}
