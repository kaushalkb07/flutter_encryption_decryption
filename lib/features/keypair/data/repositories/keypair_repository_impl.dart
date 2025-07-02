// lib/features/keypair/data/repositories/keypair_repository_impl.dart

import 'package:cryptography/cryptography.dart';
import '../../domain/entities/keypair_entity.dart';
import '../../domain/repositories/keypair_repository.dart';

class KeyPairRepositoryImpl implements KeyPairRepository {
  final X25519 _algorithm = X25519();

  @override
  Future<KeyPairEntity> generateKeyPair() async {
    final keyPair = await _algorithm.newKeyPair();
    final privateKey = await keyPair.extractPrivateKeyBytes();
    final publicKey = await keyPair.extractPublicKey();

    return KeyPairEntity(
      privateKey: privateKey,
      publicKey: publicKey.bytes,
    );
  }
}
