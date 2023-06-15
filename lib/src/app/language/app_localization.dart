import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:convert';

import 'package:a1_chat_app/src/app/language/app_local_dalegate.dart';


class AppLocalization {
  late Locale locale;

  AppLocalization(this.locale);

  static AppLocalization? of(BuildContext context) {
    return Localizations.of<AppLocalization>(context, AppLocalization);
  }

  static const LocalizationsDelegate<AppLocalization> delegate = AppLocaleDelegate();

  Map<String, String>? _localizedStrings;

  Future<bool> load() async {
    Future<Map<String, dynamic>> loadJson() async {
      String content = await rootBundle
          .loadString("assets/i18n/${locale.languageCode}.json");
      return jsonDecode(content);
    }

    final jsonMap = await loadJson();

    _localizedStrings = jsonMap.map((key, value) {
      return MapEntry(key, value.toString());
    });

    return true;
  }

  String translate(String key) {
    return _localizedStrings?[key] ?? key;
  }
}