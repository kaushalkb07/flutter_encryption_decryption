abstract class PublicKeyRepository {
  Future<void> uploadPublicKey(List<int> publicKey, String userId);
}
