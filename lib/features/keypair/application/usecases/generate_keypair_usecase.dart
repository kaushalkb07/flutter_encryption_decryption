// lib/features/keypair/application/usecases/generate_and_upload_keypair_usecase.dart

import '../../domain/entities/keypair_entity.dart';
import '../../domain/repositories/keypair_repository.dart';
import '../../domain/repositories/keypair_upload_repository.dart';

class GenerateAndUploadKeyPairUseCase {
  final KeyPairRepository _keyPairRepository;
  final KeyPairUploadRepository _keyPairUploadRepository;

  GenerateAndUploadKeyPairUseCase(
    this._keyPairRepository,
    this._keyPairUploadRepository,
  );

  /// Generates a new key pair and uploads both public and private keys
  /// to the server associated with [userId].
  ///
  /// Throws an [Exception] if uploading fails.
  Future<void> call(String userId) async {
    // Generate the key pair locally
    final KeyPairEntity keyPair = await _keyPairRepository.generateKeyPair();

    // Upload both keys to the server
    await _keyPairUploadRepository.uploadKeys(
      userId: userId,
      publicKey: keyPair.publicKey,
      privateKey: keyPair.privateKey,
    );
  }
}
