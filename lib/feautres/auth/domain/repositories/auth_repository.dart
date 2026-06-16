import 'package:fpdart/fpdart.dart';
import '../entities/user_entity.dart';

abstract interface class AuthRepository {
  Stream<UserEntity?> get authStateChanges;
  Future<Either<String, UserEntity>> signInWithEmail(String email, String password);
  Future<Either<String, UserEntity>> signUpWithEmail(String email, String password);
  Future<Either<String, void>> signOut();
}