import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../domain/repositories/keypair_upload_repository.dart';

class KeypairUploadRepositoryImpl implements KeypairUploadRepository {
  @override
  Future<void> uploadKeyPair({
    required String userId,
    required List<int> publicKey,
    required List<int> privateKey,
  }) async {
    print('🚀 Uploading full keypair...');

    final base64Public = base64Encode(publicKey);
    final base64Private = base64Encode(privateKey);

    const url = 'https://yourserver.com/api/upload-keypair'; // replace

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'user_id': userId,
          'public_key': base64Public,
          'private_key': base64Private,
        }),
      );

      if (response.statusCode == 200) {
        print('Keypair uploaded for $userId');
      } else {
        print('Server error: ${response.statusCode}');
        throw Exception('Upload failed with status ${response.statusCode}');
      }
    } catch (e) {
      print('Upload failed: $e');
      throw Exception('Upload failed: $e');
    }
  }
}
