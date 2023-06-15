import 'dart:convert';

import 'package:a1_chat_app/src/modules/messages/models/message.dart';
import 'package:hive/hive.dart';

abstract class Storage {
  Future<void> saveMessage(Message message);

  Future<List<Message?>?> getMessages();
}

class MessageStorageImpl extends Storage {
  @override
  Future<void> saveMessage(Message? message) async {
    var messageBox = await Hive.openBox('messages');
    // messageBox.clear();
    messageBox.put(message?.receivedAt?.toIso8601String(), message?.toJson());
  }

  @override
  Future<List<Message?>?> getMessages() async {
    var messageBox = await Hive.openBox('messages');
    // messageBox.clear();
    final savedMessages = messageBox.values.toList();
    final loadedMessages = savedMessages.map((message) => Message.fromJsonDb(jsonDecode(jsonEncode(message)))).toList();
    return loadedMessages;
  }
}
