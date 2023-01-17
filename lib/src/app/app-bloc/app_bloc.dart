import 'package:a1_chat_app/injector.dart';
import 'package:a1_chat_app/src/modules/socket-Io/socket_io.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'dart:async';
import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../config/app_config.dart';
import '../../modules/auth/auth-bloc/auth_cubit.dart';
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
  final SocketIO socket;

  late UserDevice device;

  AppBloc(this.deviceInfoPlugin, this.socket) : super(AppInitial()) {
    on<AppStarted>((event, emit) async {
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

        // Application.user = User(
        //   id: '1',
        //   phoneNumber: '+249924081893',
        //   name: "Ayman Sainshy",
        //   imageUrl:
        //       'https://png.pngtree.com/png-vector/20220709/ourmid/pngtree-businessman-user-avatar-wearing-suit-with-red-tie-png-image_5809521.png',
        // );

        socket.connectAndListen();

        // await Future.delayed(const Duration(milliseconds: 2000));

        injector<AuthCubit>().checkAuth();

        emit(AppSetupInComplete());
      } catch (e) {
        emit(AppSetupInFailure(e.toString()));
      }
    });
  }
}
