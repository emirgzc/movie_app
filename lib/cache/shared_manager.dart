import 'package:shared_preferences/shared_preferences.dart';

enum SharedKeys { movieName, isFavorite }

class SharedManager {
  SharedPreferences? _preferences;

  SharedManager();

  Future<void> init() async {
    _preferences = await SharedPreferences.getInstance();
  }

  void checkPreferences() {
    if (_preferences == null) {
      throw Exception('Preferences is null');
    }
  }

  Future<void> setItem(SharedKeys key, bool value) async {
    await _preferences?.setBool(key.name, value);
  }

  bool? getItem(SharedKeys key) {
    return _preferences?.getBool(key.name);
  }

  Future<bool> removeItem(SharedKeys key) async {
    return (await _preferences?.remove(key.name)) ?? false;
  }
}
