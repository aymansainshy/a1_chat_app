import 'package:flutter/material.dart';


// Get screen size without context .....
class PlatformConfigrations {
  bool get isWideMode {
    final data = MediaQueryData.fromWindow(WidgetsBinding.instance.window);
    return data.size.width > 600;
  }
}
