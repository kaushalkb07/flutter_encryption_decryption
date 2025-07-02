import '../../domain/entities/message_entity.dart';

class ChatRepositoryImpl {
  final List<MessageEntity> _messages = [];

  void addMessage(MessageEntity message) {
    _messages.add(message);
  }

  List<MessageEntity> getAllMessages() {
    return _messages;
  }
}
