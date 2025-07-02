// lib/features/chat/presentation/chat_page.dart
import 'package:flutter/material.dart';
import 'dart:convert';
import '../../../keypair/data/datasources/keypair_local_storage.dart';
import '../../data/repositories/chat_repository_impl.dart';
import '../../domain/entities/message_entity.dart';
import '../../application/usecases/encrypt_message_usecase.dart';
import '../../application/usecases/decrypt_message_usecase.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final _controller = TextEditingController();
  final _secureStorage = KeyPairLocalStorage();

  final _chatRepo = ChatRepositoryImpl();
  final List<MessageEntity> _messages = [];

  late EncryptMessageUseCase _encryptMessageUseCase;
  late DecryptMessageUseCase _decryptMessageUseCase;
  List<int> _sharedSecret = [];

  @override
  void initState() {
    super.initState();
    _encryptMessageUseCase = EncryptMessageUseCase(_chatRepo);
    _decryptMessageUseCase = DecryptMessageUseCase(_chatRepo);
    _loadSharedSecret();
  }

  Future<void> _loadSharedSecret() async {
    final base64Secret = await _secureStorage.read('shared_secret_user1_user2');
    if (base64Secret != null) {
      _sharedSecret = base64Decode(base64Secret);
    }
  }

  Future<void> _sendMessage(String sender, String receiver) async {
    final text = _controller.text;
    if (text.isEmpty || _sharedSecret.isEmpty) return;

    final encrypted = await _encryptMessageUseCase.call(text, _sharedSecret);
    final decrypted =
        await _decryptMessageUseCase.call(encrypted, _sharedSecret);

    setState(() {
      _messages.add(MessageEntity(
        sender: sender,
        receiver: receiver,
        plainText: decrypted,
        encryptedText: encrypted,
      ));
      _controller.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Secure Chat')),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: _messages.length,
                itemBuilder: (_, i) {
                  final msg = _messages[i];
                  return ListTile(
                    title: Text('Encrypted: ${msg.encryptedText}'),
                    subtitle: Text('Decrypted: ${msg.plainText}'),
                    leading: Text(msg.sender),
                  );
                },
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration:
                        const InputDecoration(hintText: 'Type a message...'),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: () => _sendMessage('user1', 'user2'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
