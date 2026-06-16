

import 'package:firebase_auth/firebase_auth.dart';
import 'package:riverpod/legacy.dart';
//import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod/riverpod.dart';
import '../../data/datasources/auth_remote_datasource.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/usecases/sign_in_usecase.dart';
import '../../domain/usecases/sign_out_usecase.dart';
import '../../domain/usecases/sign_up_usecase.dart';
import 'auth_state.dart';

// — Infrastructure providers
final firebaseAuthProvider = Provider<FirebaseAuth>(
      (_) => FirebaseAuth.instance,
);

final authRemoteDataSourceProvider = Provider<AuthRemoteDataSource>(
      (ref) => AuthRemoteDataSourceImpl(ref.watch(firebaseAuthProvider)),
);

final authRepositoryProvider = Provider<AuthRepository>(
      (ref) => AuthRepositoryImpl(ref.watch(authRemoteDataSourceProvider)),
);

// — Use case providers
final signInUseCaseProvider = Provider(
      (ref) => SignInUseCase(ref.watch(authRepositoryProvider)),
);

final signUpUseCaseProvider = Provider(
      (ref) => SignUpUseCase(ref.watch(authRepositoryProvider)),
);

final signOutUseCaseProvider = Provider(
      (ref) => SignOutUseCase(ref.watch(authRepositoryProvider)),
);

// — Auth state stream (for app-level auth guard)
final authStateStreamProvider = StreamProvider(
      (ref) => ref.watch(authRepositoryProvider).authStateChanges,
);

// — Notifier: the main state controller for login/signup actions
class AuthNotifier extends StateNotifier<AuthState> {
  final SignInUseCase _signIn;
  final SignUpUseCase _signUp;
  final SignOutUseCase _signOut;

  AuthNotifier(this._signIn, this._signUp, this._signOut)
      : super(const AuthInitial());

  Future<void> signIn(String email, String password) async {
    state = const AuthLoading();
    final result = await _signIn(email, password);
    result.fold(
          (error) => state = AuthError(error),
          (user) => state = AuthAuthenticated(user),
    );
  }

  Future<void> signUp(String email, String password) async {
    state = const AuthLoading();
    final result = await _signUp(email, password);
    result.fold(
          (error) => state = AuthError(error),
          (user) => state = AuthAuthenticated(user),
    );
  }

  Future<void> signOut() async {
    state = const AuthLoading();
    await _signOut();
    state = const AuthUnauthenticated();
  }

  void resetState() => state = const AuthInitial();
}

final authNotifierProvider = StateNotifierProvider<AuthNotifier, AuthState>(
      (ref) => AuthNotifier(
    ref.watch(signInUseCaseProvider),
    ref.watch(signUpUseCaseProvider),
    ref.watch(signOutUseCaseProvider),
  ),
);