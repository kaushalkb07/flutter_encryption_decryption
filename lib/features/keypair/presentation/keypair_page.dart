import 'dart:convert';
import 'package:flutter/material.dart';
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
  String _uploadStatus = '';

  Future<void> _handleKeyGenerationAndUpload() async {
    final generateKeyUseCase = GenerateKeyPairUseCase(KeyPairRepositoryImpl());
    final uploadKeyUseCase = UploadKeypairUseCase(KeypairUploadRepositoryImpl());

    setState(() {
      _uploadStatus = '🔄 Generating keys...';
    });

    try {
      final keyPair = await generateKeyUseCase.call();

      final encodedPublic = base64Encode(keyPair.publicKey);
      final encodedPrivate = base64Encode(keyPair.privateKey);

      setState(() {
        _publicKey = encodedPublic;
        _privateKey = encodedPrivate;
        _uploadStatus = '📤 Uploading to server...';
      });

      await uploadKeyUseCase.call(
        userId: 'user_001', // Replace with actual user ID logic
        publicKey: keyPair.publicKey,
        privateKey: keyPair.privateKey,
      );

      setState(() {
        _uploadStatus = '✅ Upload complete';
      });
    } catch (e) {
      setState(() {
        _uploadStatus = '❌ Upload failed: $e';
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _handleKeyGenerationAndUpload();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('🔐 Key Generator & Uploader')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: SelectableText(
            '📌 Public Key (Base64):\n$_publicKey\n\n'
            '🔒 Private Key (Base64):\n$_privateKey\n\n'
            '📡 Status: $_uploadStatus',
            style: const TextStyle(fontSize: 14),
          ),
        ),
      ),
    );
  }
}
