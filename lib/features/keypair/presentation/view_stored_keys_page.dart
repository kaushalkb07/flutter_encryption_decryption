import 'dart:convert';
import 'package:flutter/material.dart';
import '../data/datasources/keypair_local_storage.dart';

class ViewStoredKeysPage extends StatefulWidget {
  const ViewStoredKeysPage({super.key});

  @override
  State<ViewStoredKeysPage> createState() => _ViewStoredKeysPageState();
}

class _ViewStoredKeysPageState extends State<ViewStoredKeysPage> {
  String _publicKey = 'Loading...';
  String _privateKey = 'Loading...';
  String _deviceId = 'Loading...';

  @override
  void initState() {
    super.initState();
    _loadKeys();
  }

  Future<void> _loadKeys() async {
    final storage = KeyPairLocalStorage();
    final pubKey = await storage.getPublicKey();
    final privKey = await storage.getPrivateKey();
    final deviceId = await storage.getOrCreateDeviceId();

    setState(() {
      _publicKey = pubKey != null ? base64Encode(pubKey) : '❌ Not Found';
      _privateKey = privKey != null ? base64Encode(privKey) : '❌ Not Found';
      _deviceId = deviceId;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('🔐 Stored Keys')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: SelectableText(
            '📱 Device ID:\n$_deviceId\n\n'
            '🔑 Private Key:\n$_privateKey\n\n'
            '🔐 Public Key:\n$_publicKey',
            style: const TextStyle(fontSize: 15),
          ),
        ),
      ),
    );
  }
}
