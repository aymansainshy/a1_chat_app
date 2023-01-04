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

// class AppBlocs {
//   static final AuthCubit authCubit = AuthCubit();
//   static final AppBloc appBloc = AppBloc();
//   static final OtpBloc otpBloc = OtpBloc();

//   static final List<BlocProvider> providers = [
//     BlocProvider<AuthCubit>(create: (context) => authCubit),
//     BlocProvider<AppBloc>(create: (context) => appBloc),
//     BlocProvider<OtpBloc>(create: (context) => otpBloc),
//   ];

//   static void dispose() {
//     authCubit.close();
//     appBloc.close();
//     otpBloc.close();
//   }

//   ///Singleton factory
//   static final AppBlocs _instance = AppBlocs._internal();

//   factory AppBlocs() {
//     return _instance;
//   }

//   AppBlocs._internal();
// }

final injector = GetIt.instance;

void setup() {
  // Blocs
  injector.registerLazySingleton<AppBloc>(() => AppBloc(injector(), injector()));
  injector.registerLazySingleton<OtpBloc>(() => OtpBloc());
  injector.registerLazySingleton<AuthCubit>(() => AuthCubit());
  injector.registerLazySingleton<MessageBloc>(() => MessageBloc(injector()));

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
