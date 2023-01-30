import '../../../modules/messages/models/message.dart';
import '../../../modules/storage/storage.dart';

abstract class MessageRepository {
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
}
