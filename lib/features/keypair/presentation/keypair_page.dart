import 'dart:convert';
import 'package:flutter/material.dart';
import '../data/datasources/keypair_local_storage.dart';
import '../application/usecases/generate_keypair_usecase.dart';
import '../application/usecases/upload_keypair_usecase.dart';
import '../data/repositories/keypair_repository_impl.dart';
import '../data/repositories/keypair_upload_repository_impl.dart';

class KeyPairPage extends StatefulWidget {
  const KeyPairPage({super.key});

  @override
  State<KeyPairPage> createState() => _KeyPairPageState();
}

class _KeyPairPageState extends State<KeyPairPage> {
  String _publicKey = '';
  String _privateKey = '';
  String _deviceId = '';
  String _uploadStatus = '';
  final _localStorage = KeyPairLocalStorage();

  @override
  void initState() {
    super.initState();
    _loadOrGenerateKeyPair();
  }

  Future<void> _loadOrGenerateKeyPair() async {
    try {
      final publicKey = await _localStorage.getPublicKey();
      final privateKey = await _localStorage.getPrivateKey();
      final deviceId = await _localStorage.getOrCreateDeviceId();
      final userId = 'user_001'; // Replace this with actual user id (e.g., from auth)

      _deviceId = deviceId;

      if (publicKey != null && privateKey != null) {
        // Already exists locally
        setState(() {
          _publicKey = base64Encode(publicKey);
          _privateKey = base64Encode(privateKey);
          _uploadStatus = '✅ Keys already exist locally';
        });
        return;
      }

      // Generate new keypair
      final generateUseCase = GenerateKeyPairUseCase(KeyPairRepositoryImpl());
      final keyPair = await generateUseCase.call();

      await _localStorage.saveKeyPair(
        publicKey: keyPair.publicKey,
        privateKey: keyPair.privateKey,
      );

      // Upload keys
      final uploadUseCase = UploadKeypairUseCase(KeypairUploadRepositoryImpl());
      await uploadUseCase.call(
        userId: userId,
        deviceId: deviceId,
        publicKey: keyPair.publicKey,
        privateKey: keyPair.privateKey,
      );

      setState(() {
        _publicKey = base64Encode(keyPair.publicKey);
        _privateKey = base64Encode(keyPair.privateKey);
        _uploadStatus = '✅ Keypair generated and uploaded';
      });
    } catch (e) {
      setState(() {
        _uploadStatus = '❌ Error: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('🔐 KeyPair Info')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SelectableText(
          '📱 Device ID:\n$_deviceId\n\n'
          '🔓 Public Key (Base64):\n$_publicKey\n\n'
          '🔒 Private Key (Base64):\n$_privateKey\n\n'
          '📤 Upload Status:\n$_uploadStatus',
          style: const TextStyle(fontSize: 14),
        ),
      ),
    );
  }
}
