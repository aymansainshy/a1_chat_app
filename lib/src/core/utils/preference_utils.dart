import '../../config/app_config.dart';

class PreferencesUtils {
  
  static Future<bool?> clear() async {
    return await Application.preferences?.clear();
  }

  static bool? containsKey(String key) {
    return Application.preferences?.containsKey(key);
  }

  static dynamic get(String key) {
    return Application.preferences?.get(key);
  }

  static bool? getBool(String key) {
    return Application.preferences?.getBool(key);
  }

  static double? getDouble(String key) {
    return Application.preferences?.getDouble(key);
  }

  static int? getInt(String key) {
    return Application.preferences?.getInt(key);
  }

  static Set<String>? getKeys() {
    return Application.preferences?.getKeys();
  }

  static String? getString(String key) {
    return Application.preferences?.getString(key);
  }

  static List<String>? getStringList(String key) {
    return Application.preferences?.getStringList(key);
  }

  static Future<void> reload() async {
    return await Application.preferences?.reload();
  }

  static Future<bool?> remove(String key) async {
    return await Application.preferences?.remove(key);
  }

  static Future<bool?> setBool(String key, bool value) async {
    return await Application.preferences?.setBool(key, value);
  }

  static Future<bool?> setDouble(String key, double value) async {
    return await Application.preferences?.setDouble(key, value);
  }

  static Future<bool?> setInt(String key, int value) async {
    return await Application.preferences?.setInt(key, value);
  }

  static Future<bool?> setString(String key, String value) async {
    return await Application.preferences?.setString(key, value);
  }

  static Future<bool?> setStringList(String key, List<String> value) async {
    return await Application.preferences?.setStringList(key, value);
  }

  ///Singleton factory
  static final PreferencesUtils _instance = PreferencesUtils._internal();

  factory PreferencesUtils() {
    return _instance;
  }

  PreferencesUtils._internal();
}