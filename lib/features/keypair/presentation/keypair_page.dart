// lib/features/keypair/presentation/keypair_page.dart

import 'package:flutter/material.dart';
import '../application/usecases/generate_keypair_usecase.dart';
import '../data/repositories/keypair_repository_impl.dart';
import '../data/repositories/keypair_upload_repository_impl.dart';

class KeyPairPage extends StatefulWidget {
  const KeyPairPage({super.key});

  @override
  State<KeyPairPage> createState() => _KeyPairPageState();
}

class _KeyPairPageState extends State<KeyPairPage> {
  String _status = 'Press button to generate and upload keys';

  Future<void> _generateAndUpload() async {
    setState(() {
      _status = 'Generating keys...';
    });

    final userId = 'user_001'; // Replace with actual logged-in user ID
    final baseUrl = 'https://dropweb.cloud'; // Your backend base URL

    final generateUseCase = GenerateAndUploadKeyPairUseCase(
      KeyPairRepositoryImpl(),
      KeyPairUploadRepositoryImpl(baseUrl),
    );

    try {
      await generateUseCase.call(userId);
      setState(() {
        _status = 'Keys generated and uploaded successfully!';
      });
    } catch (e) {
      setState(() {
        _status = 'Failed to upload keys: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Key Pair Generator')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(_status, textAlign: TextAlign.center),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _generateAndUpload,
                child: const Text('Generate & Upload Keys'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
