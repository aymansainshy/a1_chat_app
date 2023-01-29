import 'package:dio/dio.dart';

import '../../../config/app_config.dart';
import '../models/user_model.dart';

abstract class OnlineUserRepository {
  Future<List<User>?>? getOnlineUsers();
}

class OnlineUserRepositoryImpl extends OnlineUserRepository {
  @override
  Future<List<User>?>? getOnlineUsers() async {
    try {
      final response = await Dio().get("${Application.domain}/online-users");
      final loadedData = response.data['data'] as List<dynamic>;
      final List<User> users =  loadedData.map((user) => User.fromJson(user)).toList();
      return users;
    } catch (e) {
      rethrow;
    }
  }
}
