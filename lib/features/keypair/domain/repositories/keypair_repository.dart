import '../entities/keypair_entity.dart';

abstract class KeyPairRepository {
  Future<KeyPairEntity> generateKeyPair();
}
