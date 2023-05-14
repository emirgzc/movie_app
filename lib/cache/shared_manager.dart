import 'package:shared_preferences/shared_preferences.dart';

enum SharedKeys { movieName, isFavorite, themeMode, shouldWatch }

abstract class SharedAbstract {
  Future<void> init();
  void checkPreferences();
  Future<void> setItem(SharedKeys key, bool value);
  bool? getItem(SharedKeys key);
  Future<bool> removeItem(SharedKeys key);
}

class SharedManager extends SharedAbstract {
  SharedPreferences? _preferences;

  SharedManager();

  @override
  void checkPreferences() {
    if (_preferences == null) {
      throw Exception('Preferences is null');
    }
  }

  @override
  bool? getItem(SharedKeys key) {
    return _preferences?.getBool(key.name);
  }

  @override
  Future<void> init() async {
    _preferences = await SharedPreferences.getInstance();
  }

  @override
  Future<bool> removeItem(SharedKeys key) async {
    return (await _preferences?.remove(key.name)) ?? false;
  }

  @override
  Future<void> setItem(SharedKeys key, bool value) async {
    await _preferences?.setBool(key.name, value);
  }
}
