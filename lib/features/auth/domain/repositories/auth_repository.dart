abstract class AuthRepository {
  Future<String> login({required String username, required String password});
}
