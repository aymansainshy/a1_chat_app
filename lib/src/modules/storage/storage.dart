import 'dart:convert';

import 'package:a1_chat_app/src/modules/messages/models/message.dart';
import 'package:hive/hive.dart';

abstract class Storage {
  Future<void> saveMessage(Message message);

  Future<List<Message?>?>  getMessages();
}

class MessageStorageImpl extends Storage {
  @override
  Future<void> saveMessage(Message message) async {
    var messageBox = await Hive.openBox('messages');

    messageBox.delete(message.id);
    messageBox.put(message.id, message.toJson());

    print('Saved messages ..... ${messageBox.values.toList()}');
    // messageBox.clear();
  }

  @override
  Future<List<Message?>?> getMessages() async {
    var  messageBox = await Hive.openBox('messages');
    final savedMessages = messageBox.values.toList();
    print('Loaded Saved messages ..... ${messageBox.values.toList()}');
    final loadedMessages = savedMessages.map((message) => Message.fromJson(jsonDecode(jsonEncode(message)))).toList();
    return  loadedMessages;
  }
}
