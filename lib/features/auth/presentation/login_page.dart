import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../application/usecases/login_usecase.dart';
import '../data/repositories/auth_repository_impl.dart';

// Keypair Imports
import '../../keypair/application/usecases/generate_keypair_usecase.dart';
import '../../keypair/application/usecases/upload_keypair_usecase.dart';
import '../../keypair/data/datasources/keypair_local_storage.dart';
import '../../keypair/data/repositories/keypair_repository_impl.dart';
import '../../keypair/data/repositories/keypair_upload_repository_impl.dart';
import '../../keypair/presentation/keypair_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _secureStorage = const FlutterSecureStorage();

  String _status = '';

  Future<void> _handleLogin() async {
    final loginUseCase = LoginUseCase(AuthRepositoryImpl());
    final localStorage = KeyPairLocalStorage();

    setState(() => _status = 'Logging in...');

    try {
      final token = await loginUseCase(
        _usernameController.text.trim(),
        _passwordController.text.trim(),
      );

      final userId = _usernameController.text.trim(); // or extract from token
      await _secureStorage.write(key: 'auth_token', value: token);

      // KEYPAIR LOGIC
      final public = await localStorage.getPublicKey();
      final private = await localStorage.getPrivateKey();
      final deviceId = await localStorage.getOrCreateDeviceId();

      if (public == null || private == null) {
        final generateUseCase = GenerateKeyPairUseCase(KeyPairRepositoryImpl());
        final uploadUseCase = UploadKeypairUseCase(KeypairUploadRepositoryImpl());
        final keyPair = await generateUseCase();

        await localStorage.saveKeyPair(publicKey: keyPair.publicKey, privateKey: keyPair.privateKey);
        await uploadUseCase.call(
          userId: userId,
          deviceId: deviceId,
          publicKey: keyPair.publicKey,
          privateKey: keyPair.privateKey,
        );

        _status = '🔐 Key pair generated and uploaded.';
      } else {
        _status = '✅ Key already exists locally.';
      }

      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const KeyPairPage()),
        );
      }
    } catch (e) {
      setState(() => _status = '❌ Login failed: $e');
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
            TextField(controller: _usernameController, decoration: const InputDecoration(labelText: 'Username')),
            TextField(controller: _passwordController, obscureText: true, decoration: const InputDecoration(labelText: 'Password')),
            const SizedBox(height: 16),
            ElevatedButton(onPressed: _handleLogin, child: const Text('Login')),
            const SizedBox(height: 20),
            Text(_status),
          ],
        ),
      ),
    );
  }
}
