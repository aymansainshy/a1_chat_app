
import 'package:shared_preferences/shared_preferences.dart';

import '../modules/online-users/model/user.dart';

class Application {
  static bool debug = true;
  static String version = '1.0.0';
  static String domain = 'Domain.com';
  static SharedPreferences? preferences;
  // static bool isEnglish = AppLanguage.defaultLanguage.languageCode == 'en';
  static Device? device;
  static bool isDarktheme = false;
  static String storagePath = '';
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

class Device {
}