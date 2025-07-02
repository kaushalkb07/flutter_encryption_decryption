// lib/features/auth/application/usecases/login_usecase.dart

import '../../domain/repositories/auth_repository.dart';

class LoginUseCase {
  final AuthRepository repository;

  LoginUseCase(this.repository);

  Future<String> call({required String username, required String pass}) {
    return repository.login(username: username, pass: pass);
  }
}
