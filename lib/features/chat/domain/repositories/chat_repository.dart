// lib/features/chat/domain/repositories/chat_repository.dart

abstract class ChatRepository {
  Future<String> encrypt(String message, List<int> sharedSecret);
  Future<String> decrypt(String encryptedBase64, List<int> sharedSecret);
}
