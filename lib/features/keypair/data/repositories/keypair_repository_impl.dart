import 'dart:convert';
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
  @override
  Future<void> uploadPublicKey(List<int> publicKey, String userId) async {
    final base64Key = base64Encode(publicKey);
    const url = 'https://yourserver.com/api/upload-key'; // Replace with your actual API

    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'user_id': userId,
        'public_key': base64Key,
      }),
    );

    if (response.statusCode == 200) {
      print('Public key uploaded successfully');
    } else {
      throw Exception('Failed to upload key: ${response.statusCode} ${response.body}');
    }
  }
}
