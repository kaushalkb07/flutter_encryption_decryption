import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../domain/repositories/keypair_upload_repository.dart';

class KeypairUploadRepositoryImpl implements KeypairUploadRepository {
  static const _uploadUrl = 'https://yourserver.com/api/register-key'; // Replace with your endpoint

  @override
  Future<void> uploadKeypair({
    required String userId,
    required String deviceId,
    required List<int> publicKey,
    required List<int> privateKey,
  }) async {
    final base64Public = base64Encode(publicKey);
    final base64Private = base64Encode(privateKey);

    final body = jsonEncode({
      'user_id': userId,
      'device_id': deviceId,
      'public_key': base64Public,
      'private_key': base64Private,
    });

    final response = await http.post(
      Uri.parse(_uploadUrl),
      headers: {'Content-Type': 'application/json'},
      body: body,
    );

    if (response.statusCode != 200) {
      throw Exception('Upload failed: ${response.statusCode} ${response.body}');
    }
  }
}
