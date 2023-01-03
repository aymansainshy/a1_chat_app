import 'package:a1_chat_app/src/modules/messages/models/message.dart';

abstract class Storage {
  Future<void> saveMessage(Message message);

  Future<List<Message>?> getMessages();
}

class MessageStorageImpl extends Storage {
  @override
  Future<void> saveMessage(Message message) async {}

  @override
  Future<List<Message>?> getMessages() async {
    return null;
  }
}
