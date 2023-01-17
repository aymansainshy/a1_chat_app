import 'package:a1_chat_app/src/app/root_app_widget.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

import 'package:a1_chat_app/injector.dart' as injector;
import 'package:hydrated_bloc/hydrated_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // HydratedBloc.storage = await HydratedStorage.build(storageDirectory: await getApplicationDocumentsDirectory());
  injector.setup();
  runApp(const MyApp());
}
