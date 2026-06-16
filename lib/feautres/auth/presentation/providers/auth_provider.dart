import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:riverpod/legacy.dart';
import 'package:riverpod/riverpod.dart';
import '../../../../core/providers/user_provider.dart';
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

// ← NOW passes 2 arguments: FirebaseAuth + FirebaseFirestore
final authRemoteDataSourceProvider = Provider<AuthRemoteDataSource>(
      (ref) => AuthRemoteDataSourceImpl(
    ref.watch(firebaseAuthProvider),
    FirebaseFirestore.instance, // ← 2nd argument added here
  ),
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

// — Auth state stream
final authStateStreamProvider = StreamProvider(
      (ref) => ref.watch(authRepositoryProvider).authStateChanges,
);

// — Notifier
class AuthNotifier extends StateNotifier<AuthState> {
  final SignInUseCase _signIn;
  final SignUpUseCase _signUp;
  final SignOutUseCase _signOut;
  final UserNotifier _userNotifier;


  AuthNotifier(this._signIn, this._signUp, this._signOut,this._userNotifier)
      : super(const AuthInitial());

  Future<void> signIn(String email, String password) async {
    state = const AuthLoading();
    final result = await _signIn(email, password);
    result.fold(
          (error) => state = AuthError(error),
          (user) async {
        await _userNotifier.saveUser(user); // ← save to SharedPreferences
        state = AuthAuthenticated(user);
      },
    );
  }

  Future<void> signUp(String email, String password, String fullName) async {
    state = const AuthLoading();
    final result = await _signUp(email, password, fullName);
    result.fold(
          (error) => state = AuthError(error),
          (user) async {
        await _userNotifier.saveUser(user); // ← save to SharedPreferences
        state = AuthAuthenticated(user);
      },
    );
  }


  Future<void> signOut() async {
    state = const AuthLoading();
    await _signOut();
    await _userNotifier.clearUser(); // ← clear SharedPreferences
    state = const AuthUnauthenticated();
  }

  void resetState() => state = const AuthInitial();
}

final authNotifierProvider = StateNotifierProvider<AuthNotifier, AuthState>(
      (ref) => AuthNotifier(
    ref.watch(signInUseCaseProvider),
    ref.watch(signUpUseCaseProvider),
    ref.watch(signOutUseCaseProvider),
        ref.watch(userProvider.notifier),
      ),
);