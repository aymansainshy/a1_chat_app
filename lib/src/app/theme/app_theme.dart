import 'package:flutter/material.dart';

import '../../core/animations/custom_page_transition.dart';

class AppColors {
  static const Color primaryColor = Color.fromARGB(255, 41, 78, 200);
  static const Color accentColor = Color.fromRGBO(251, 112, 214, 1);
  static const Color cardColor = Color.fromRGBO(255, 255, 255, 1);
  static const Color backgroundColor = Color.fromARGB(255, 232, 235, 243);
  static const Color indicatorColor = Color.fromRGBO(100, 223, 151, 1);
  static const Color borderColor = Colors.black;
  static const Color textButtomColor = Colors.white;
  static const Color blackGray = Colors.black45;
  static const Color iconColors = Colors.grey;
}

final colorScheme = ColorScheme.fromSwatch(
  primarySwatch: Colors.blue,
  accentColor: AppColors.accentColor,
  cardColor: AppColors.cardColor,
  backgroundColor: AppColors.backgroundColor,
);

class AppTheme {
  static final lightTheme = ThemeData(
    brightness: Brightness.light,
    fontFamily: "Roboto",
    useMaterial3: true,
    primaryColor: AppColors.primaryColor,
    indicatorColor: AppColors.indicatorColor,
    cardColor:AppColors.cardColor ,
    // scaffoldBackgroundColor: AppColors.backgroundColor,
    pageTransitionsTheme: PageTransitionsTheme(builders: {
      TargetPlatform.android: CustomPageTransitionBuilder(),
      TargetPlatform.iOS: CustomPageTransitionBuilder(),
    }), colorScheme: colorScheme.copyWith(background: AppColors.backgroundColor),
  );

  static final darkTheme = ThemeData(
    brightness: Brightness.light,
    primarySwatch: Colors.blue,
    fontFamily: "Roboto",
    // useMaterial3: true,
    colorScheme: colorScheme,
    pageTransitionsTheme: PageTransitionsTheme(builders: {
      TargetPlatform.android: CustomPageTransitionBuilder(),
      TargetPlatform.iOS: CustomPageTransitionBuilder(),
    }),
  );
}
