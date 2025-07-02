abstract class KeyPairUploadRepository {
  Future<void> uploadKeys({
    required String userId,
    required List<int> publicKey,
    required List<int> privateKey,
  });
}