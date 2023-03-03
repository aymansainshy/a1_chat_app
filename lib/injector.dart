import 'package:a1_chat_app/src/app/theme/theme_cubit.dart';
import 'package:a1_chat_app/src/modules/auth/repository/auth_repository.dart';
import 'package:a1_chat_app/src/modules/messages/message-bloc/message_bloc.dart';
import 'package:a1_chat_app/src/modules/messages/message-bloc/single_message_bloc/single_message_bloc.dart';
import 'package:a1_chat_app/src/modules/messages/repository/messages_repository.dart';
import 'package:a1_chat_app/src/modules/online-users/online-users-bloc/online_users_bloc.dart';
import 'package:a1_chat_app/src/modules/online-users/repository/user_repository.dart';
import 'package:a1_chat_app/src/modules/socket-Io/socket_io.dart';
import 'package:a1_chat_app/src/modules/storage/storage.dart';
import 'package:a1_chat_app/src/router/app_router.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:get_it/get_it.dart';

import 'package:a1_chat_app/src/modules/auth/auth-bloc/auth_cubit.dart';
import 'package:a1_chat_app/src/modules/auth/auth-bloc/otp_bloc.dart';
import 'package:a1_chat_app/src/app/app-bloc/app_bloc.dart';

import 'src/modules/home/button_switcher_cubit.dart';

final injector = GetIt.instance;

void setup() {
  // Blocs
  injector.registerLazySingleton<AppBloc>(() => AppBloc(injector()));
  injector.registerLazySingleton<OtpBloc>(() => OtpBloc(injector()));
  injector.registerLazySingleton<AuthCubit>(() => AuthCubit(injector()));
  injector.registerLazySingleton<MessageBloc>(() => MessageBloc(injector(), injector()));
  injector.registerLazySingleton<ThemeCubit>(() => ThemeCubit());
  injector.registerLazySingleton<ButtonSwitcherCubit>(() => ButtonSwitcherCubit());
  injector.registerLazySingleton<OnlineUsersBloc>(() => OnlineUsersBloc(injector()));
  injector.registerLazySingleton<SingleMessageBloc>(() => SingleMessageBloc(injector(), injector()));

  // Repositories
  injector.registerLazySingleton<MessageRepository>(() => MessageRepositoryImpl(injector()));
  injector.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl());
  injector.registerLazySingleton<OnlineUserRepository>(() => OnlineUserRepositoryImpl());

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
