import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart';
import 'package:cryptography/cryptography.dart';
import 'package:http/http.dart' as http;
import '../../domain/entities/keypair_entity.dart';
import '../../domain/repositories/keypair_repository.dart';


// Implementation of Key (Private and Public)
class KeyPairRepositoryImpl implements KeyPairRepository {
  @override
  Future<KeyPairEntity> generateKeyPair() async {
    final algorithm = X25519(); // Or use Ecdsa.p256(Sha256())
    final keyPair = await algorithm.newKeyPair();
    final privateKey = await keyPair.extractPrivateKeyBytes();
    final publicKey = await keyPair.extractPublicKey();

    return KeyPairEntity(
      publicKey: publicKey.bytes,
      privateKey: privateKey, // This must match the constructor
    );
  }
}

// implements the contract defined in the domain layer.
class PublicKeyRepositoryImpl implements PublicKeyRepository {
  final _firestore = FirebaseFirestore.instance;

  @override
  Future<void> uploadPublicKey(List<int> publicKey, String userId) async {
    final base64Key = base64Encode(publicKey);

    await _firestore.collection('users').doc(userId).set({
      'public_key': base64Key,
      'updated_at': FieldValue.serverTimestamp(),
    });

    print('✅ Public key uploaded to Firestore for $userId');
  }
}
