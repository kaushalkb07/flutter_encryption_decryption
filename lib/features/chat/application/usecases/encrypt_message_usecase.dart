// lib/features/chat/application/usecases/encrypt_message_usecase.dart

import '../../domain/repositories/chat_repository.dart';

class EncryptMessageUseCase {
  final ChatRepository repository;

  EncryptMessageUseCase(this.repository);

  Future<String> call(String message, List<int> sharedSecret) {
    return repository.encrypt(message, sharedSecret);
  }
}
