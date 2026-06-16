import 'package:fpdart/fpdart.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_datasource.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _dataSource;
  AuthRepositoryImpl(this._dataSource);

  @override
  Stream<UserEntity?> get authStateChanges => _dataSource.authStateChanges;

  @override
  Future<Either<String, UserEntity>> signInWithEmail(
      String email, String password) async {
    try {
      final user = await _dataSource.signInWithEmail(email, password);
      return Right(user);
    } on FirebaseAuthException catch (e) {
      return Left(_mapFirebaseError(e.code));
    }
  }

  @override
  Future<Either<String, UserEntity>> signUpWithEmail(
      String email, String password) async {
    try {
      final user = await _dataSource.signUpWithEmail(email, password);
      return Right(user);
    } on FirebaseAuthException catch (e) {
      return Left(_mapFirebaseError(e.code));
    }
  }

  @override
  Future<Either<String, void>> signOut() async {
    try {
      await _dataSource.signOut();
      return const Right(null);
    } catch (e) {
      return Left(e.toString());
    }
  }

  String _mapFirebaseError(String code) {
    switch (code) {
      case 'user-not-found': return 'No account found with this email.';
      case 'wrong-password': return 'Incorrect password.';
      case 'email-already-in-use': return 'This email is already registered.';
      case 'weak-password': return 'Password must be at least 6 characters.';
      case 'invalid-email': return 'Please enter a valid email.';
      case 'network-request-failed': return 'Check your internet connection.';
      default: return 'Something went wrong. Please try again.';
    }
  }
}