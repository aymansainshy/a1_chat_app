import 'package:a1_chat_app/src/modules/messages/message-bloc/message_bloc.dart';
import 'package:a1_chat_app/src/modules/messages/repository/messages_repository.dart';
import 'package:a1_chat_app/src/modules/socket-Io/socket_io.dart';
import 'package:a1_chat_app/src/modules/storage/storage.dart';
import 'package:a1_chat_app/src/router/app_router.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:get_it/get_it.dart';

import 'package:a1_chat_app/src/modules/auth/auth-bloc/auth_cubit.dart';
import 'package:a1_chat_app/src/modules/auth/auth-bloc/otp_bloc.dart';
import 'package:a1_chat_app/src/app/app-bloc/app_bloc.dart';

final injector = GetIt.instance;

void setup() {
  // Blocs
  injector.registerLazySingleton<AppBloc>(() => AppBloc(injector(), injector()));
  injector.registerLazySingleton<OtpBloc>(() => OtpBloc());
  injector.registerLazySingleton<AuthCubit>(() => AuthCubit());
  injector.registerLazySingleton<MessageBloc>(() => MessageBloc(injector(), injector()));

  // Repositories
  injector.registerLazySingleton<MessageRepository>(() => MessageRepositoryImpl(injector()));

  // Storage 
  injector.registerLazySingleton<Storage>(() => MessageStorageImpl());

  // AppRouter
  injector.registerLazySingleton<AppRouter>(() => AppRouter(injector()));

  // WebSocket
  injector.registerLazySingleton<SocketIO>(() => SocketIoImpl());

  // External
  final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
  injector.registerLazySingleton(() => deviceInfoPlugin);
}
