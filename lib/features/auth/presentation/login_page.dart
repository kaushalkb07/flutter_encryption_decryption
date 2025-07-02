// lib/features/auth/presentation/login_page.dart

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../application/usecases/login_usecase.dart';
import '../data/repositories/auth_repository_impl.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _usernameController = TextEditingController();
  final _passController = TextEditingController();
  String _status = '';

  Future<void> _handleLogin() async {
    final loginUseCase = LoginUseCase(
      AuthRepositoryImpl(baseUrl: 'https://yourserver.com'), // ✅ update URL
    );

    try {
      final token = await loginUseCase.call(
        username: _usernameController.text.trim(),
        pass: _passController.text.trim(),
      );

      setState(() {
        _status = 'Login successful! Token saved.';
      });

      // Optionally print token
      print('Auth Token: $token');
    } catch (e) {
      setState(() {
        _status = 'Login failed: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _usernameController,
              decoration: const InputDecoration(labelText: 'Username'),
            ),
            TextField(
              controller: _passController,
              decoration: const InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _handleLogin,
              child: const Text('Login'),
            ),
            const SizedBox(height: 16),
            Text(_status),
          ],
        ),
      ),
    );
  }
}
