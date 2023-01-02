

import 'package:a1_chat_app/src/modules/auth/auth-bloc/auth_cubit.dart';
import 'package:a1_chat_app/src/modules/auth/auth-bloc/otp_bloc.dart';
import 'package:a1_chat_app/src/modules/home/app-bloc/app_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AppBlocs {
  static final AuthCubit authCubit = AuthCubit();
  static final AppBloc appBloc = AppBloc();
  static final OtpBloc otpBloc = OtpBloc();

  static final List<BlocProvider> providers = [
    BlocProvider<AuthCubit>(create: (context) => authCubit),
    BlocProvider<AppBloc>(create: (context) => appBloc),
    BlocProvider<OtpBloc>(create: (context) => otpBloc),
  ];

  static void dispose() {
    authCubit.close();
    appBloc.close();
    otpBloc.close();
  }

  ///Singleton factory
  static final AppBlocs _instance = AppBlocs._internal();

  factory AppBlocs() {
    return _instance;
  }

  AppBlocs._internal();
}
