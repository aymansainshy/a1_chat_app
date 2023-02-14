import 'package:a1_chat_app/injector.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../../../config/app_config.dart';
import '../../../core/constan/const.dart';
import '../../../modules/messages/message-bloc/message_bloc.dart';
import '../../../modules/messages/models/message.dart';
import '../../../modules/storage/storage.dart';

abstract class MessageRepository {
  Future<List<Message?>> fetchUserMessages();

  Future<List<Message?>> fetchUserReceivedMessages();

  Future<void> fetchMessages();

  List<Message?>? getMessages();

  Future<void> saveMessage(Message message);
}

class MessageRepositoryImpl extends MessageRepository {
  final Storage messageStorage;

  MessageRepositoryImpl(this.messageStorage);

  late List<Message?>? messages = [];

  @override
  List<Message?>? getMessages() {
    return messages;
  }

  @override
  Future<void> saveMessage(Message message) async {
    messageStorage.saveMessage(message);
  }

  @override
  Future<void> fetchMessages() async {
    messages = await messageStorage.getMessages();
  }

  @override
  Future<List<Message?>> fetchUserMessages() async {
    try {
      final response = await Dio().get(
        "${Application.domain}/user-messages/${Application.user?.id}",
        options: Options(
          sendTimeout: 5000,
          receiveTimeout: 5000,
          headers: {
            'Content-type': 'application/json',
            'Accept': 'application/json',
            'Authorization': 'Bearer ${Application.user?.token}'
          },
        ),
      );

      final loadedData = response.data['data'] as List<dynamic>;
      final List<Message> userMessages = loadedData.map((message) => Message.fromJsonSocketIO(message)).toList();

      if (kDebugMode) {
        print("User Sending Messages");
        logger.i(userMessages.toString());
      }

      for (var message in userMessages) {
        if (message.isRead) {
          injector<MessageBloc>().add(MessageRead(message: message));
        }
        if (message.isDelivered) {
          injector<MessageBloc>().add(MessageDelivered(message: message));
        }
      }

      return userMessages;
    } catch (error) {
      rethrow;
    }
  }

  @override
  Future<List<Message?>> fetchUserReceivedMessages() async {
    try {
      final response = await Dio().get(
        "${Application.domain}/user-received-messages/${Application.user?.id}",
        options: Options(
          sendTimeout: 5000,
          receiveTimeout: 5000,
          headers: {
            'Content-type': 'application/json',
            'Accept': 'application/json',
            'Authorization': 'Bearer ${Application.user?.token}'
          },
        ),
      );

      final loadedData = response.data['data'] as List<dynamic>;
      final List<Message> userMessages = loadedData.map((message) => Message.fromJsonSocketIO(message)).toList();

      return userMessages;
    } catch (error) {
      if (kDebugMode) {
        print(error.toString());
      }
      rethrow;
    }
  }
}
