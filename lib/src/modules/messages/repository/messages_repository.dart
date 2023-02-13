import 'package:dio/dio.dart';
import 'package:logger/logger.dart';

import '../../../config/app_config.dart';
import '../../../modules/messages/models/message.dart';
import '../../../modules/storage/storage.dart';

var logger = Logger(
  printer: PrettyPrinter(),
);

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
          sendTimeout: 2000,
          receiveTimeout: 1000,
          headers: {
            'Content-type': 'application/json',
            'Accept': 'application/json',
            'Authorization': 'Bearer ${Application.user?.token}'
          },
        ),
      );

      final loadedData = response.data['data'] as List<dynamic>;
      final List<Message> userMessages = loadedData.map((message) => Message.fromJsonApi(message)).toList();
      print("User Sending Messages");
      logger.i(userMessages.toString());

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
          sendTimeout: 2000,
          receiveTimeout: 1000,
          headers: {
            'Content-type': 'application/json',
            'Accept': 'application/json',
            'Authorization': 'Bearer ${Application.user?.token}'
          },
        ),
      );

      final loadedData = response.data['data'] as List<dynamic>;
      final List<Message> userMessages = loadedData.map((message) => Message.fromJsonApi(message)).toList();
      print("User Received Messages");
      logger.i(userMessages.toString());

      return userMessages;
    } catch (error) {
      print(error.toString());
      rethrow;
    }
  }
}
