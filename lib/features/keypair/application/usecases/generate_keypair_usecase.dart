import '../../domain/entities/keypair_entity.dart';
import '../../domain/repositories/keypair_repository.dart';

class GenerateKeyPairUseCase {
  final KeyPairRepository repository;

  GenerateKeyPairUseCase(this.repository);

  Future<KeyPairEntity> call() => repository.generateKeyPair();
}
