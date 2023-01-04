import 'package:a1_chat_app/injector.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../config/app_config.dart';
import '../../modules/auth/auth-bloc/auth_cubit.dart';

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

class AppSetupInFailer extends AppState {
  final String error;

  const AppSetupInFailer(this.error);
}

class AppBloc extends Bloc<AppEvent, AppState> {
  final DeviceInfoPlugin deviceInfoPlugin;
  late UserDevice device;

  AppBloc(this.deviceInfoPlugin) : super(AppInitial()) {
    on<AppStarted>((event, emit) async {
      // Read Save Device Information
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

        print("Device ${device.name}");
      } catch (e) {
        print("Device setup error $e");
      }


     Application.device = device;

     injector<AuthCubit>().checkAuth();

     await Future.delayed(const Duration(milliseconds: 2000));

     emit(AppSetupInComplete());
      //TODO: when app started ...
    });
  }
}