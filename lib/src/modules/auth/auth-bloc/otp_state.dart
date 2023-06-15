

part of './otp_bloc.dart';

abstract class OtpState extends Equatable {
  const OtpState();

  @override
  List<Object> get props => [];
}

class OtpInitial extends OtpState {}

// Sending Otp ......
class SendOtpInProgress extends OtpState {}

class SendOtpSuccess extends OtpState {}

class SendOtpFaliure extends OtpState {
  final String error;
  // final DioError error;

  const SendOtpFaliure(this.error);
}


class VarifyOtpInProgress extends OtpState {}

class VarifyOtpSuccess extends OtpState {}

class VarifyOtpFaliure extends OtpState {
  final String error;
  // final DioError error;

  const VarifyOtpFaliure(this.error);
}