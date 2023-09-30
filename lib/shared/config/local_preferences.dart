import 'package:shared_preferences/shared_preferences.dart';

class LocalPreferences {
  late SharedPreferences _prefs;
  bool _isInitialized = false;

  LocalPreferences() {
    getPreferences();
  }

  Future<void> getPreferences() async {
    if (!_isInitialized) {
      _prefs = await SharedPreferences.getInstance();
      _isInitialized = true;
    }
  }

  Future<bool> clear() async {
    await getPreferences();
    return _prefs.clear();
  }

  Future<bool> setString(String key, String value) async {
    await getPreferences();
    return _prefs.setString(key, value);
  }

  Future<String?> getString(String key) async {
    await getPreferences();
    return _prefs.getString(key);
  }
}
