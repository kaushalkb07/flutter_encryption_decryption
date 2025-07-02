// lib/features/auth/data/repositories/auth_repository_impl.dart

import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import '../../domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final String baseUrl;
  final FlutterSecureStorage storage = const FlutterSecureStorage();

  AuthRepositoryImpl({required this.baseUrl});

  @override
  Future<String> login({required String username, required String pass}) async {
    final url = Uri.parse('$baseUrl/api/v1/auth/login');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'username': username.trim(), // ✅ change from 'email'
        'pass': pass.trim(),         // ✅ change from 'password'
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final token = data['token'] as String;

      // Save token securely
      await storage.write(key: 'auth_token', value: token);
      return token;
    } else {
      print('Login failed: ${response.statusCode} ${response.body}');
      throw Exception('Login failed: ${response.statusCode}');
    }
  }

  @override
  Future<void> logout() async {
    await storage.delete(key: 'auth_token');
  }

  @override
  Future<String?> getToken() async {
    return await storage.read(key: 'auth_token');
  }
}
