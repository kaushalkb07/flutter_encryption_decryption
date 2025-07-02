class MessageEntity {
  final String sender;
  final String encryptedMessage;
  final String decryptedMessage;

  MessageEntity({
    required this.sender,
    required this.encryptedMessage,
    required this.decryptedMessage,
  });
}
