
import 'dart:io';

import 'package:shared_preferences/shared_preferences.dart';

import '../core/language/app_lang.dart';
import '../modules/online-users/models/user_model.dart';

class Application {
  static bool debug = true;
  static String version = '1.0.0';
  static String domain = 'http://192.168.43.104:3333';
  static SharedPreferences? preferences;
  static bool isEnglish = AppLanguage.defaultLanguage.languageCode == 'en';
  static UserDevice? device;
  static bool isDarktheme = false;
  static Directory? storageDir;
  static User? user;

  static bool isUserUnknown() {
    return user == null;
  }

  ///Singleton factory
  static final Application _instance = Application._internal();

  factory Application() {
    return _instance;
  }

  Application._internal();
}

class UserDevice {
  final String? uuid;
  final String? name;
  final String? model;
  final String? version;
  final String? type;

  UserDevice({
    this.uuid,
    this.name,
    this.model,
    this.version,
    this.type,
  });
}
