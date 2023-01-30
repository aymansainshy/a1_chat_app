import '../../../modules/messages/models/message.dart';
import '../../../modules/storage/storage.dart';

abstract class MessageRepository {
  Future<List<Message?>?> getMessages();

  Future<void> saveMessage(Message message);
}

class MessageRepositoryImpl extends MessageRepository {
  final Storage messageStorage;

  MessageRepositoryImpl(this.messageStorage);

  @override
  Future<List<Message?>?> getMessages() async {
    final messages = await messageStorage.getMessages();
    return messages;
  }

  @override
  Future<void> saveMessage(Message message) async {
    messageStorage.saveMessage(message);
  }
}
