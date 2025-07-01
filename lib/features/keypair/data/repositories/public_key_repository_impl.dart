import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../domain/repositories/public_key_repository_impl.dart';

class PublicKeyRepositoryImpl implements PublicKeyRepository {
  @override
  Future<void> uploadPublicKey(List<int> publicKey, String userId) async {
    print('Attempting to upload public key...');

    final base64Key = base64Encode(publicKey);
    const url = 'https://yourserver.com/api/upload-key'; // ← replace with actual

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'userId': userId,
          'publicKey': base64Key,
        }),
      );

      if (response.statusCode == 200) {
        print('✅ Uploaded public key for $userId');
      } else {
        print('Server error: ${response.statusCode}');
        print('Body: ${response.body}');
        throw Exception('Upload failed with status: ${response.statusCode}');
      }
    } catch (e) {
      print('Upload failed: $e');
      throw Exception('Upload failed: $e');
    }
  }
}

