import 'package:fpdart/fpdart.dart';
import '../entities/user_entity.dart';
import '../repositories/auth_repository.dart';

class SignInUseCase {
  final AuthRepository _repository;
  const SignInUseCase(this._repository);

  Future<Either<String, UserEntity>> call(String email, String password) {
    return _repository.signInWithEmail(email, password);
  }
}