import 'package:a1_chat_app/src/app/app_config_model.dart';
import 'package:dio/dio.dart';
import 'package:talker_dio_logger/talker_dio_logger_interceptor.dart';
import 'package:talker_dio_logger/talker_dio_logger_settings.dart';

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
  final _dio = Dio();

  talkerDioLogger() {
    return TalkerDioLogger(
      settings: const TalkerDioLoggerSettings(
        printRequestHeaders: true,
        printResponseHeaders: true,
        printResponseMessage: true,
      ),
    );
  }

  @override
  Future<OtpResponse> sendOtp(String phoneNumber) async {
    try {
      _dio.interceptors.add(talkerDioLogger());

      final response = await _dio.post(
        "${Application.domain}/login",
        options: Options(
          sendTimeout: const Duration(milliseconds: 1000),
          receiveTimeout: const Duration(milliseconds: 1000),
          headers: {
            'Content-type': 'application/json',
            'Accept': 'application/json',
          },
        ),
        data: {"phone_number": phoneNumber},
      );
      final responseData = response.data as Map<String, dynamic>;
      return OtpResponse(responseData['code'].toString(), responseData['message'], responseData['data']);
    } on DioError {
      rethrow;
    }
  }

  @override
  Future<User?> confirmOtp(String otp, String phoneNumber) async {
    try {
      _dio.interceptors.add(talkerDioLogger());

      final response = await _dio.post(
        "${Application.domain}/login/confirmotp",
        options: Options(
          sendTimeout:const Duration(milliseconds: 2000),
          receiveTimeout: const Duration(milliseconds: 1000),
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

      return user;
    } on DioError {
      rethrow;
    }
  }
}
