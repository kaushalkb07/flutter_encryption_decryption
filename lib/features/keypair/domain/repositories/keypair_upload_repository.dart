abstract class KeypairUploadRepository {
  Future<void> uploadKeyPair({
    required String userId,
    required List<int> publicKey,
    required List<int> privateKey,
  });
}
