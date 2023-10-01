import 'dart:convert';

import 'package:ojo_courier/models/user.entity.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalPreferences {
  late SharedPreferences _prefs;
  bool _isInitialized = false;

  LocalPreferences() {
    _getPreferences();
  }

  Future<void> _getPreferences() async {
    if (!_isInitialized) {
      _prefs = await SharedPreferences.getInstance();
      _isInitialized = true;
    }
  }

  Future<bool> clear() async {
    await _getPreferences();
    return _prefs.clear();
  }

  Future<bool> _setString(String key, String value) async {
    await _getPreferences();
    return _prefs.setString(key, value);
  }

  Future<String?> _getString(String key) async {
    await _getPreferences();
    return _prefs.getString(key);
  }

  Future<User?> getUser() async {
    await _getPreferences();
    final userJson = await _getString('user');
    if (userJson == null) return null;
    User user = User.fromJson(json.decode(userJson));
    return user;
  }

  Future<User?> setUser(User user) async {
    await _getPreferences();
    final userSaved = await _setString('user', json.encode(user.toJson()));
    return userSaved ? user : null;
  }
}
