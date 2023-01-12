import 'package:flutter/material.dart';

import '../animations/custom_page_transition.dart';

class AppColors {
  static const Color primaryColor = Color.fromRGBO(86, 122, 244, 1);
  static const Color accentColor = Color.fromRGBO(251, 112, 214, 1);
  static const Color cardColor = Color.fromRGBO(255, 255, 255, 1);
  static const Color backgroundColor = Color.fromRGBO(233, 239, 253, 1);
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
    colorScheme: colorScheme,
    primaryColor: AppColors.primaryColor,
    indicatorColor: AppColors.indicatorColor,
    pageTransitionsTheme: PageTransitionsTheme(builders: {
      TargetPlatform.android: CustomPageTransitionBuilder(),
      TargetPlatform.iOS: CustomPageTransitionBuilder(),
    }),
  );

  static final darkTheme = ThemeData(
    brightness: Brightness.light,
    primarySwatch: Colors.blue,
    fontFamily: "Roboto",
    colorScheme: colorScheme,
    pageTransitionsTheme: PageTransitionsTheme(builders: {
      TargetPlatform.android: CustomPageTransitionBuilder(),
      TargetPlatform.iOS: CustomPageTransitionBuilder(),
    }),
  );
}
