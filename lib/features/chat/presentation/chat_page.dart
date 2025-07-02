import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:cryptography/cryptography.dart';

import '../domain/entities/message_entity.dart';
import '../data/repositories/chat_repository_impl.dart';
import '../application/usecases/encrypt_message_usecase.dart';
import '../application/usecases/decrypt_message_usecase.dart';

class ChatPage extends StatefulWidget {
  final List<int> sharedSecret;

  const ChatPage({super.key, required this.sharedSecret});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final _messageController = TextEditingController();
  final _chatRepo = ChatRepositoryImpl();
  late SecretKey _secretKey;

  @override
  void initState() {
    super.initState();
    _secretKey = SecretKey(widget.sharedSecret);
  }

  void _sendMessage(String sender) async {
    final plainText = _messageController.text.trim();
    if (plainText.isEmpty) return;

    final encryptUseCase = EncryptMessageUseCase(_secretKey);
    final encrypted = await encryptUseCase.call(plainText);
    final decryptUseCase = DecryptMessageUseCase(_secretKey);
    final decrypted = await decryptUseCase.call(encrypted);

    final message = MessageEntity(
      sender: sender,
      encryptedMessage: base64Encode(encrypted),
      decryptedMessage: decrypted,
    );

    setState(() {
      _chatRepo.addMessage(message);
      _messageController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    final messages = _chatRepo.getAllMessages();

    return Scaffold(
      appBar: AppBar(title: const Text('Encrypted Chat')),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: messages.length,
                itemBuilder: (_, index) {
                  final msg = messages[index];
                  return ListTile(
                    title: Text('Encrypted: ${msg.encryptedMessage}'),
                    subtitle: Text('Decrypted: ${msg.decryptedMessage}'),
                    trailing: Text(msg.sender),
                  );
                },
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: const InputDecoration(
                      labelText: 'Type a message...',
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: () => _sendMessage('User1'),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
