import 'package:a1_chat_app/src/modules/messages/models/message.dart';

abstract class Storage {}

class MessageStorageImpl extends Storage {
  Future<void> saveMessage(Message message) async {}

  Future<List<Message>?> getMessages() async {}
}
