import 'package:flutter/material.dart';
import '../application/usecases/generate_keypair_usecase.dart';
import '../data/repositories/keypair_repository_impl.dart';

class KeyPairPage extends StatefulWidget {
  const KeyPairPage({Key? key}) : super(key: key);

  @override
  State<KeyPairPage> createState() => _KeyPairPageState();
}

class _KeyPairPageState extends State<KeyPairPage> {
  String publicKey = '';
  String privateKey = '';

  @override
  void initState() {
    super.initState();
    _generateKeys();
  }

  Future<void> _generateKeys() async {
    final useCase = GenerateKeyPairUseCase(KeyPairRepositoryImpl());
    final keyPair = await useCase();

    setState(() {
      publicKey = keyPair.publicKey.toString();
      privateKey = keyPair.privateKey.toString();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Key Pair Generator')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SelectableText(
          'Private Key:\n$privateKey\n\nPublic Key:\n$publicKey',
          style: TextStyle(fontSize: 14),
        ),
      ),
    );
  }
}

// Call this function after generating keyPairEntity (public & private keys)
Future<void> uploadUserPublicKey(List<int> publicKey) async {
  final uploader = UploadPublicKeyUseCase(PublicKeyRepositoryImpl());
  try {
    await uploader(publicKey, 'user_001'); // Replace with actual user ID
    print('Uploaded public key to Firestore');
  } catch (e) {
    print('Error uploading key: $e');
  }
}