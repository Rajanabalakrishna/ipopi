

import 'package:fpdart/fpdart.dart';
import '../entities/user_entity.dart';
import '../repositories/auth_repository.dart';

class SignUpUseCase {
  final AuthRepository _repository;
  const SignUpUseCase(this._repository);

  Future<Either<String, UserEntity>> call(String email, String password) {
    return _repository.signUpWithEmail(email, password);
  }
}