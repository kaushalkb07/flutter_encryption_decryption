abstract class SharedSecretRepository {
  Future<List<int>> generateSharedSecret({
    required List<int> myPrivateKey,
    required List<int> otherPublicKey,
  });
}
