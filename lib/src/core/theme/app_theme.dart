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

}

// This generates the modern simplified set of theme colors flutter recommends
// using when theming Widgets based on the theme. Set it manually if you need
// more control over individual colors
final colorScheme = ColorScheme.fromSwatch(
  primarySwatch: Colors.blue, // as above
  // primaryColorDark: primaryColorDark, // as above
  accentColor: AppColors.accentColor, // as above
  cardColor: AppColors.cardColor, // default based on theme brightness, can be set manually
  backgroundColor: AppColors.backgroundColor, // as above
  // errorColor: errorColor, // default (Colors.red[700]), can be set manually
  // brightness: brightness, // default (Brightness.light), can be set manually
);

class AppTheme {
  static final lightTheme = ThemeData(
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
    primarySwatch: Colors.blue,
  );
}
