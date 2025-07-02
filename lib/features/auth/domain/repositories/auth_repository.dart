abstract class AuthRepository {
  Future<String> login({required String username, required String pass});
  Future<void> logout();
  Future<String?> getToken();
}
