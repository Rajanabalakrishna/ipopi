import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/shared_pref_service.dart';
import '../../feautres/auth/domain/entities/user_entity.dart';

// SharedPreferences instance provider
final sharedPrefProvider = Provider<SharedPrefService>((ref) {
  throw UnimplementedError('Override in ProviderScope');
});

// UserEntity state — null means not logged in
class UserNotifier extends StateNotifier<UserEntity?> {
  final SharedPrefService _prefs;

  UserNotifier(this._prefs) : super(null) {
    _loadFromPrefs(); // auto-load on init
  }

  void _loadFromPrefs() {
    final data = _prefs.loadUser();
    if (data != null) {
      state = UserEntity(
        uid:         data['uid']!,
        email:       data['email'],
        displayName: data['fullName'],
        photoUrl:    data['photoUrl'],
      );
    }
  }

  Future<void> saveUser(UserEntity user) async {
    await _prefs.saveUser(
      uid:      user.uid,
      email:    user.email,
      fullName: user.displayName,
      photoUrl: user.photoUrl,
    );
    state = user;
  }

  Future<void> clearUser() async {
    await _prefs.clearUser();
    state = null;
  }
}

final userProvider = StateNotifierProvider<UserNotifier, UserEntity?>(
      (ref) => UserNotifier(ref.watch(sharedPrefProvider)),
);