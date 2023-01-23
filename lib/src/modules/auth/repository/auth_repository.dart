import 'package:a1_chat_app/src/config/app_config.dart';
import 'package:dio/dio.dart';

import '../../online-users/models/user_model.dart';

class OtpResponse {
  final String? code;
  final String? message;
  final String? data;

  OtpResponse(this.code, this.message, this.data);
}

abstract class AuthRepository {
  Future<OtpResponse> sendOtp(String phoneNumber);

  Future<User?> confirmOtp(String otp, String phoneNumber);
}

class AuthRepositoryImpl extends AuthRepository {
  @override
  Future<OtpResponse> sendOtp(String phoneNumber) async {
    try {
      final response = await Dio().post(
        "${Application.domain}/login",
        options: Options(
          sendTimeout: 2000,
          receiveTimeout: 1000,
          headers: {
            'Content-type': 'application/json',
            'Accept': 'application/json',
          },
        ),
        data: {"phone_number": phoneNumber},
      );
      final responseData = response.data as Map<String, dynamic>;
      print(responseData.toString());
      return OtpResponse(responseData['code'].toString(),
          responseData['message'], responseData['data']);
    } on DioError {
      rethrow;
    }
  }

  @override
  Future<User?> confirmOtp(String otp, String phoneNumber) async {
    try {
      final response = await Dio().post(
        "${Application.domain}/login/confirmotp",
        options: Options(
          sendTimeout: 2000,
          receiveTimeout: 1000,
          headers: {
            'Content-type': 'application/json',
            'Accept': 'application/json',
          },
        ),
        data: {
          "phone_number": phoneNumber,
          "otp": otp,
        },
      );
      final responseData = response.data as Map<String, dynamic>;
      User? user = User(
        id: responseData['data']['id'].toString(),
        name: responseData['data']['name'],
        imageUrl: responseData['data']['image_Url'],
        phoneNumber: responseData['data']['phone_number'],
        token: responseData['data']['token'],
      );
      print(responseData.toString());
      return user;
    } on DioError catch(e){
      print(e.toString());
      rethrow;
    }
  }
}
