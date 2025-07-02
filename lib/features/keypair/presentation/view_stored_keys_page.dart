import 'package:flutter/material.dart';
import '../data/datasources/keypair_local_storage.dart'; // Adjust path if needed

class ViewStoredKeysPage extends StatefulWidget {
  const ViewStoredKeysPage({super.key});

  @override
  State<ViewStoredKeysPage> createState() => _ViewStoredKeysPageState();
}

class _ViewStoredKeysPageState extends State<ViewStoredKeysPage> {
  late final KeyPairLocalStorage _localStorage;
  String _publicKey = '';
  String _privateKey = '';

  @override
  void initState() {
    super.initState();
    _localStorage = KeyPairLocalStorage();
    _loadStoredKeys();
  }

  Future<void> _loadStoredKeys() async {
    final keys = await _localStorage.getKeys();
    if (keys != null) {
      setState(() {
        _publicKey = keys['publicKey']!;
        _privateKey = keys['privateKey']!;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Stored Keys')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SelectableText(
          'Public Key (base64):\n$_publicKey\n\nPrivate Key (base64):\n$_privateKey',
        ),
      ),
    );
  }
}
