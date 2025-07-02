// lib/features/chat/application/usecases/decrypt_message_usecase.dart

import '../../domain/repositories/chat_repository.dart';

class DecryptMessageUseCase {
  final ChatRepository repository;

  DecryptMessageUseCase(this.repository);

  Future<String> call(String encryptedMessage, List<int> sharedSecret) {
    return repository.decrypt(encryptedMessage, sharedSecret);
  }
}
