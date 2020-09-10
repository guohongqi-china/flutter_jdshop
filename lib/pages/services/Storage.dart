import 'package:shared_preferences/shared_preferences.dart';

class Storage {
  static Future<void> setString(key, value) async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    sp.setString(key, value);
  }

  static Future<bool> setStringList(key, value) async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    return await sp.setStringList(key, value);
  }

  static Future<String> getString(key) async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    return sp.getString(key);
  }

  static getStringList(key) async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    return sp.getStringList(key);
  }

  static Future<bool> remove(key) async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    return await sp.remove(key);
  }

  static Future<void> clear(key, value) async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    sp.clear();
  }
}
