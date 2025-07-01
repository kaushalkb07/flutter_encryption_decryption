import 'dart:convert';
import 'package:flutter/material.dart';
import '../application/usecases/generate_keypair_usecase.dart';
import '../application/usecases/upload_public_key_usecase.dart';
import '../data/repositories/keypair_repository_impl.dart';
import '../data/repositories/public_key_repository_impl.dart';

class KeyPairPage extends StatefulWidget {
  const KeyPairPage({super.key});

  @override
  State<KeyPairPage> createState() => _KeyPairPageState();
}

class _KeyPairPageState extends State<KeyPairPage> {
  String _publicKey = '';
  String _privateKey = '';
  String _uploadStatus = '';

  Future<void> _handleKeyGeneration() async {
    final keyPairUseCase = GenerateKeyPairUseCase(KeyPairRepositoryImpl());
    final uploadUseCase = UploadPublicKeyUseCase(PublicKeyRepositoryImpl());

    final keyPair = await keyPairUseCase.call();

    final pubEncoded = base64Encode(keyPair.publicKey);
    final privEncoded = base64Encode(keyPair.privateKey);

    setState(() {
      _publicKey = pubEncoded;
      _privateKey = privEncoded;
      _uploadStatus = 'Uploading...';
    });

    try {
      await uploadUseCase.call(keyPair.publicKey, 'user_001');
      setState(() {
        _uploadStatus = 'Upload complete';
      });
    } catch (e) {
      setState(() {
        _uploadStatus = 'Upload failed: $e';
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _handleKeyGeneration();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Key Generator')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: SelectableText(
            'Public Key (base64):\n$_publicKey\n\n'
            'Private Key (base64):\n$_privateKey\n\n'
            'Upload Status: $_uploadStatus',
          ),
        ),
      ),
    );
  }
}