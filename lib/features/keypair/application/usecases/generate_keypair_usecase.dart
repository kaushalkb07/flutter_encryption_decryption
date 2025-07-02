// lib/features/keypair/application/usecases/generate_and_upload_keypair_usecase.dart

import '../../domain/entities/keypair_entity.dart';
import '../../domain/repositories/keypair_repository.dart';
import '../../domain/repositories/keypair_upload_repository.dart';

class GenerateKeyPairUseCase {
  final KeyPairRepository _keyPairRepository;

  GenerateKeyPairUseCase(this._keyPairRepository);

  Future<KeyPairEntity> call() async {
    return await _keyPairRepository.generateKeyPair();
  }
}

