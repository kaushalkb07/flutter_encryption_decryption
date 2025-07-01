import 'package:cryptography/cryptography.dart';
import '../../domain/entities/keypair_entity.dart';
import '../../domain/repositories/keypair_repository.dart';

class KeyPairRepositoryImpl implements KeyPairRepository {
  @override
  Future<KeyPairEntity> generateKeyPair() async {
    final algorithm = X25519();
    final keyPair = await algorithm.newKeyPair();
    final privateKey = await keyPair.extractPrivateKeyBytes();
    final publicKey = await keyPair.extractPublicKey();

    return KeyPairEntity(
      publicKey: publicKey.bytes,
      privateKey: privateKey,
    );
  }
}
