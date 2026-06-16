

import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefService {
  static const _keyUserId    = 'user_id';
  static const _keyEmail     = 'user_email';
  static const _keyFullName  = 'user_full_name';
  static const _keyPhotoUrl  = 'user_photo_url';

  final SharedPreferences _prefs;
  SharedPrefService(this._prefs);

  // Save after login/signup
  Future<void> saveUser({
    required String uid,
    required String? email,
    required String? fullName,
    required String? photoUrl,
  }) async {
    await _prefs.setString(_keyUserId, uid);
    if (email != null)    await _prefs.setString(_keyEmail, email);
    if (fullName != null) await _prefs.setString(_keyFullName, fullName);
    if (photoUrl != null) await _prefs.setString(_keyPhotoUrl, photoUrl);
  }

  // Load on app start
  Map<String, String?>? loadUser() {
    final uid = _prefs.getString(_keyUserId);
    if (uid == null) return null; // not logged in
    return {
      'uid':      uid,
      'email':    _prefs.getString(_keyEmail),
      'fullName': _prefs.getString(_keyFullName),
      'photoUrl': _prefs.getString(_keyPhotoUrl),
    };
  }

  // Clear on logout
  Future<void> clearUser() async {
    await _prefs.remove(_keyUserId);
    await _prefs.remove(_keyEmail);
    await _prefs.remove(_keyFullName);
    await _prefs.remove(_keyPhotoUrl);
  }

  bool get isLoggedIn => _prefs.getString(_keyUserId) != null;
}