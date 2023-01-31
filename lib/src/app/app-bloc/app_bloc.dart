import 'dart:convert';

import 'package:a1_chat_app/injector.dart';
import 'package:a1_chat_app/src/modules/online-users/online-users-bloc/online_users_bloc.dart';
import 'package:a1_chat_app/src/modules/socket-Io/socket_io.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'dart:async';
import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../config/app_config.dart';
import '../../config/preferences_config.dart';
import '../../core/utils/preference_utils.dart';
import '../../modules/auth/auth-bloc/auth_cubit.dart';
import '../../modules/messages/repository/messages_repository.dart';
import '../../modules/online-users/models/user_model.dart';

abstract class AppEvent extends Equatable {
  const AppEvent();

  @override
  List<Object> get props => [];
}

class AppStarted extends AppEvent {}

abstract class AppState extends Equatable {
  const AppState();

  @override
  List<Object> get props => [];
}

// APPLICATION STATE
class AppInitial extends AppState {}

class AppSetupInProgress extends AppState {}

class AppSetupInComplete extends AppState {}

class AppSetupInFailure extends AppState {
  final String error;

  const AppSetupInFailure(this.error);
}

class AppBloc extends Bloc<AppEvent, AppState> {
  final DeviceInfoPlugin deviceInfoPlugin;


  late UserDevice device;

  AppBloc(this.deviceInfoPlugin) : super(AppInitial()) {
    on<AppStarted>((event, emit) async {
      Application.preferences = await SharedPreferences.getInstance();
      // PreferencesUtils.clear();

      ///Setting local storage path
      Application.storagePath = (await getApplicationDocumentsDirectory()).path;

      // Read Save Device Information
      try {
        emit(AppSetupInProgress());

        try {
          if (Platform.isAndroid) {
            final android = await deviceInfoPlugin.androidInfo;

            device = UserDevice(
              uuid: android.id,
              name: "Android",
              model: android.model,
              version: android.version.sdkInt.toString(),
              type: android.type,
            );
          } else if (Platform.isIOS) {
            final IosDeviceInfo ios = await deviceInfoPlugin.iosInfo;

            device = UserDevice(
              uuid: ios.identifierForVendor,
              name: ios.name,
              model: ios.systemName,
              version: ios.systemVersion,
              type: ios.utsname.machine,
            );
          }
        } catch (e) {
          // print("Device setup error $e");
        }

        Application.device = device;

        //Setup user if Exist ......
        if (PreferencesUtils.containsKey(Preferences.user)!) {
          String? userData = PreferencesUtils.getString(Preferences.user);

          if (userData != null) {
            Application.user = User.fromJson(jsonDecode(userData));
            await injector<MessageRepository>().fetchMessages();
          }
        }


        injector<AuthCubit>().checkAuth();
        injector<OnlineUsersBloc>().add(GetOnlineUser());

        await Future.delayed(const Duration(milliseconds: 1000));

        emit(AppSetupInComplete());
      } catch (e) {
        emit(AppSetupInFailure(e.toString()));
      }
    });
  }
}
