
import 'package:a1_chat_app/src/app/root_app_widget.dart';
import 'package:flutter/material.dart';

import 'package:a1_chat_app/injector.dart' as injector;


void main() {
  WidgetsFlutterBinding.ensureInitialized();
  injector.setup();
  runApp(const MyApp());
}


