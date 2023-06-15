import 'package:flutter/material.dart';

class AppLanguage {
  ///Default Language
  static Locale defaultLanguage = const Locale("en");

  ///List Language support in Application
  static List<Locale> supportLanguage = const[
    Locale("en"),
    Locale("ar"),
  ];

  ///Singleton factory
  static final AppLanguage _instance = AppLanguage._internal();

  factory AppLanguage() {
    return _instance;
  }

  AppLanguage._internal();
}