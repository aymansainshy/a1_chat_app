import 'package:a1_chat_app/src/modules/messages/models/message.dart';

abstract class Storage {
  Future<void> saveMessage(MessageRoom messageRoom);

  Future<Map<String, MessageRoom>?> getMessages();
}

class MessageStorageImpl extends Storage {
  @override
  Future<void> saveMessage(MessageRoom messageRoom) async {}

  @override
  Future<Map<String, MessageRoom>?> getMessages() async {
    return null;
  }
}
