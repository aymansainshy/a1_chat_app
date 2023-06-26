import 'package:a1_chat_app/src/app/root_app_widget.dart';
import 'package:flutter/material.dart';

import 'package:a1_chat_app/injector.dart' as injector;
import 'package:hive_flutter/adapters.dart';
// import 'package:path_provider/path_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  injector.setup();
  runApp(const MyApp());
}


// <uses-permission android:name="android.permission.INTERNET"/>
// <uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE"/>
// <uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE"/>
