abstract class KeypairUploadRepository {
  Future<void> uploadKeypair({
    required String userId,
    required String deviceId,
    required List<int> publicKey,
    required List<int> privateKey,
  });
}
