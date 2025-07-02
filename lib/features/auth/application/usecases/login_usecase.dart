import '../../domain/repositories/auth_repository.dart';

class LoginUseCase {
  final AuthRepository repository;

  LoginUseCase(this.repository);

  Future<String> call(String username, String password) {
    return repository.login(username: username, password: password);
  }
}
