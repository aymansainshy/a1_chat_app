import 'package:a1_chat_app/src/app/language/app_lang.dart';
import 'package:a1_chat_app/src/app/language/app_localization.dart';
import 'package:flutter/material.dart';

class AppLocaleDelegate extends LocalizationsDelegate<AppLocalization> {
  const AppLocaleDelegate();

  @override
  bool isSupported(Locale locale) {
    return AppLanguage.supportLanguage.contains(locale);
  }

  @override
  Future<AppLocalization> load(Locale locale) async {
    AppLocalization localizations = AppLocalization(locale);
    await localizations.load();
    return localizations;
  }

  @override
  bool shouldReload(AppLocaleDelegate old) => false;
}