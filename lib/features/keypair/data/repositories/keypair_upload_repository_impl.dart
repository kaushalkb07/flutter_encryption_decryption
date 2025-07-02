// lib/features/keypair/data/repositories/keypair_upload_repository_impl.dart

import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../domain/repositories/keypair_upload_repository.dart';

class KeyPairUploadRepositoryImpl implements KeyPairUploadRepository {
  final String baseUrl;

  // Hardcoded token for quick testing - replace with your actual token
  final String _hardcodedToken =
      'eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.eyJfaWQiOiI2ODRkMzYzNjM0OTQxMTA3OWY0ZjkwYTciLCJ1c2VybmFtZSI6ImRyb3AiLCJzZXNzaW9uSWQiOiI2ODY0YjVjMTUzNjM0OTQ1YmFmMzIwZTEiLCJpYXQiOjE3NTE0MzA1OTQsImV4cCI6MTc1MjAzNTM5NH0.IMqtawKMbFZGtw6GEXvVr88JsCap5bY9sorc049YFKBSfm52_nYiFlT2IcVdsoHQOI3nT1WYDFX-AsRZjbaWfwlEGYRK6UO5gD9mTBrFTfRnIdn_VcQqEnCr9Tit0N3YRGp_fKkvfsDHd_V-2Tdito2tIfMO0sRdqaJRThOvSG8';

  KeyPairUploadRepositoryImpl(this.baseUrl);

  @override
  Future<void> uploadKeys({
    required String userId,
    required List<int> publicKey,
    required List<int> privateKey,
    String? authToken, // optional, uses hardcoded if not provided
  }) async {
    final url = Uri.parse('$baseUrl/api/v1/crypto/publicKey');

    final headers = <String, String>{
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${authToken ?? _hardcodedToken}',
    };

    final body = jsonEncode({
      'user_id': userId,
      'publicKey': base64Encode(publicKey),
      'privateKey': base64Encode(privateKey),
    });

    // Debug logs for troubleshooting
    print('Uploading keys for user: $userId');
    print('Using token: ${authToken ?? _hardcodedToken}');
    print('Request URL: $url');
    print('Request Body: $body');

    try {
      final response = await http.post(url, headers: headers, body: body);

      if (response.statusCode >= 200 && response.statusCode < 300) {
        print('✅ Keys uploaded successfully');
      } else if (response.statusCode == 403) {
        throw Exception('❌ Forbidden (403): Invalid token or unauthorized');
      } else {
        throw Exception(
          '❌ Failed to upload keys\nStatus: ${response.statusCode}\nBody: ${response.body}',
        );
      }
    } catch (e) {
      print('❌ Exception during key upload: $e');
      rethrow;
    }
  }
}
