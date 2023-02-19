// ignore_for_file: unnecessary_null_comparison

import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageService {
  const LocalStorageService();

  static const _instance = LocalStorageService();
  static late final SharedPreferences _preferences;

  static Future<LocalStorageService> getInstance() async {
    print("Aqui entra");
    _preferences = await SharedPreferences.getInstance();
    return _instance;
  }

  dynamic getFromDisk(String key) {
    var value = _preferences.get(key);
    return value;
  }

  Future<void> saveToDisk<T>(String key, T content) async {
    if (content is String) {
      await _preferences.setString(key, content);
    }
    if (content is bool) {
      await _preferences.setBool(key, content);
    }
    if (content is int) {
      await _preferences.setInt(key, content);
    }
    if (content is double) {
      await _preferences.setDouble(key, content);
    }
    if (content is List<String>) {
      await _preferences.setStringList(key, content);
    }
  }

  Future<void> deleteFromDisk(String key) async {
    await _preferences.remove(key);
  }
}
