import 'dart:convert';
import 'package:flutter/material.dart';

import '../../keypair/application/usecases/generate_keypair_usecase.dart';
import '../../keypair/application/usecases/upload_keypair_usecase.dart';
import '../../keypair/application/usecases/generate_shared_secret_usecase.dart';
import '../../keypair/data/datasources/keypair_local_storage.dart';
import '../../keypair/data/repositories/keypair_repository_impl.dart';
import '../../keypair/data/repositories/keypair_upload_repository_impl.dart';
import '../../keypair/data/repositories/shared_secret_repository_impl.dart';
import '../../keypair/domain/entities/keypair_entity.dart';

class KeyPairPage extends StatefulWidget {
  const KeyPairPage({super.key});

  @override
  State<KeyPairPage> createState() => _KeyPairPageState();
}

class _KeyPairPageState extends State<KeyPairPage> {
  final KeyPairLocalStorage _secureStorage = KeyPairLocalStorage();
  final String baseUrl = 'https://dropweb.cloud'; // Your backend URL

  KeyPairEntity? _user1KeyPair;
  KeyPairEntity? _user2KeyPair;

  String _user1Pub = '';
  String _user2Pub = '';
  String _sharedSecret = '';

  String _uploadStatus = '';
  String _sharedSecretStatus = '';
  int _tapCount = 0;

  Future<void> _handleKeyGeneration() async {
    setState(() {
      _uploadStatus = 'Generating keys...';
      _sharedSecretStatus = '';
    });

    try {
      final keyPairRepo = KeyPairRepositoryImpl();
      final uploadRepo = KeyPairUploadRepositoryImpl(baseUrl);
      final generateKeyUseCase = GenerateKeyPairUseCase(keyPairRepo);
      final uploadKeyUseCase = UploadKeyPairUseCase(uploadRepo);

      final keyPair = await generateKeyUseCase.call();

      if (_tapCount == 0) {
        // User 1
        _user1KeyPair = keyPair;
        await uploadKeyUseCase.call(
          userId: 'user1',
          publicKey: keyPair.publicKey,
          privateKey: keyPair.privateKey,
          authToken:
              'eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.eyJfaWQiOiI2ODRkMzYzNjM0OTQxMTA3OWY0ZjkwYTciLCJ1c2VybmFtZSI6ImRyb3AiLCJzZXNzaW9uSWQiOiI2ODY0YjVjMTUzNjM0OTQ1YmFmMzIwZTEiLCJpYXQiOjE3NTE0MzA1OTQsImV4cCI6MTc1MjAzNTM5NH0.IMqtawKMbFZGtw6GEXvVr88JsCap5bY9sorc049YFKBSfm52_nYiFlT2IcVdsoHQOI3nT1WYDFX-AsRZjbaWfwlEGYRK6UO5gD9mTBrFTfRnIdn_VcQqEnCr9Tit0N3YRGp_fKkvfsDHd_V-2Tdito2tIfMO0sRdqaJRThOvSG8',
        );
        _user1Pub = base64Encode(keyPair.publicKey);
        _uploadStatus = 'User 1 keys uploaded.';
      } else if (_tapCount == 1) {
        // User 2
        _user2KeyPair = keyPair;
        await uploadKeyUseCase.call(
          userId: 'user2',
          publicKey: keyPair.publicKey,
          privateKey: keyPair.privateKey,
          authToken:
              'eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.eyJfaWQiOiI2ODRkMzYzNjM0OTQxMTA3OWY0ZjkwYTciLCJ1c2VybmFtZSI6ImRyb3AiLCJzZXNzaW9uSWQiOiI2ODY0YjVjMTUzNjM0OTQ1YmFmMzIwZTEiLCJpYXQiOjE3NTE0MzA1OTQsImV4cCI6MTc1MjAzNTM5NH0.IMqtawKMbFZGtw6GEXvVr88JsCap5bY9sorc049YFKBSfm52_nYiFlT2IcVdsoHQOI3nT1WYDFX-AsRZjbaWfwlEGYRK6UO5gD9mTBrFTfRnIdn_VcQqEnCr9Tit0N3YRGp_fKkvfsDHd_V-2Tdito2tIfMO0sRdqaJRThOvSG8',
        );
        _user2Pub = base64Encode(keyPair.publicKey);
        _uploadStatus = 'User 2 keys uploaded.';

        // Now generate shared secret locally
        final sharedSecretUseCase =
            GenerateSharedSecretUseCase(SharedSecretRepositoryImpl());

        final secret = await sharedSecretUseCase.call(
          myPrivateKey: _user1KeyPair!.privateKey,
          otherPublicKey: _user2KeyPair!.publicKey,
        );

        final encodedSecret = base64Encode(secret);
        await _secureStorage.save('shared_secret_user1_user2', encodedSecret);

        _sharedSecret = encodedSecret;
        _sharedSecretStatus = 'Shared secret generated and stored locally.';
      } else {
        _uploadStatus = 'All keys generated.';
      }

      _tapCount++;
    } catch (e) {
      _uploadStatus = 'Error: $e';
    }

    if (mounted) setState(() {});
  }

  Future<void> _loadSharedSecret() async {
    final secret = await _secureStorage.read('shared_secret_user1_user2');
    if (mounted) {
      setState(() {
        _sharedSecret = secret ?? 'Not generated yet.';
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _loadSharedSecret();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Key Pair Generator & Shared Secret')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ElevatedButton(
                onPressed: _tapCount < 2 ? _handleKeyGeneration : null,
                child: Text(
                  _tapCount == 0
                      ? 'Generate & Upload for User 1'
                      : _tapCount == 1
                          ? 'Generate & Upload for User 2'
                          : 'Completed',
                ),
              ),
              const SizedBox(height: 20),
              SelectableText('User 1 Public Key:\n$_user1Pub\n'),
              SelectableText('User 2 Public Key:\n$_user2Pub\n'),
              const SizedBox(height: 20),
              SelectableText('Shared Secret (base64):\n$_sharedSecret\n'),
              const SizedBox(height: 20),
              Text('Upload Status: $_uploadStatus'),
              Text('Shared Secret Status: $_sharedSecretStatus'),
            ],
          ),
        ),
      ),
    );
  }
}
