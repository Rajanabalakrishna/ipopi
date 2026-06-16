import 'package:fpdart/fpdart.dart';
import '../repositories/auth_repository.dart';

class SignOutUseCase {
  final AuthRepository _repository;
  const SignOutUseCase(this._repository);

  Future<Either<String, void>> call() {
    return _repository.signOut();
  }
}