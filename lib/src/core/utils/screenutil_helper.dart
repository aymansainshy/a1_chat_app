import 'package:flutter/material.dart';

class DivceScreenSize {
  static bool isLandScape(BuildContext context) {
    return MediaQuery.of(context).orientation == Orientation.landscape;
  }

  static Size mediaQuery(BuildContext context) {
    return MediaQuery.of(context).size;
  }

  // Singlton Factory ....
  static final DivceScreenSize _instance = DivceScreenSize._internal();

  factory DivceScreenSize() {
    return _instance;
  }

  DivceScreenSize._internal();
}
