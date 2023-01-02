// import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


// import '../../../config/app_config.dart';
import '../../../config/preferences_config.dart';
import '../../../core/utils/preference_utils.dart';

part './otp_state.dart';

abstract class OtpEvent extends Equatable {
  const OtpEvent();

  @override
  List<Object> get props => [];
}

class SendOtp extends OtpEvent {
  final String? phoneNumber;

  const SendOtp(this.phoneNumber);
}

class VarifyOtp extends OtpEvent {
  final String? otp;
  final String? phoneNumber;

  const VarifyOtp(this.phoneNumber, this.otp);
}

class OtpBloc extends Bloc<OtpEvent, OtpState> {
  OtpBloc() : super(OtpInitial()) {
    on<SendOtp>((event, emit) {
      try {
        emit(SendOtpInProgress());
        // await authRepository.sendOtp(event.phoneNumber, event.name);
        emit(SendOtpSuccess());
      } catch (error) {
        emit(SendOtpFaliure(error.toString()));
      }
    });

    on<VarifyOtp>((event, emit) {
      try {
        emit(VarifyOtpInProgress());
        // final User? user = await authRepository.confirmOtp(event.phoneNumber!, event.otp!);

        if (PreferencesUtils.containsKey(Preferences.user)!) {
          PreferencesUtils.remove(Preferences.user);
        }

        // PreferencesUtils.setString(Preferences.user, jsonEncode(user!.toJson()));

        // Application.user = user;

        emit(VarifyOtpSuccess());
      } catch (error) {
        emit(VarifyOtpFaliure(error.toString()));
      }
    });
  }
}
