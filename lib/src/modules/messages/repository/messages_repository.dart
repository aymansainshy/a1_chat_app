import '../../../modules/messages/models/message.dart';
import '../../../modules/storage/storage.dart';

abstract class MessageRepository {
  Future<List<Message?>?> getMessages();

  Future<void> saveMessage(Message message);
}

class MessageRepositoryImpl extends MessageRepository {
  final Storage messageStorage;

  MessageRepositoryImpl(this.messageStorage);

  final List<Message?>? messages = const [
    Message(
      id: '1',
      sender: '1',
      receiver: '10',
      content: 'Hello',
    ),
    Message(
      id: '3',
      sender: '10',
      receiver: '1',
      content: 'Hello',
    ),
    Message(
      id: '4',
      sender: '10',
      receiver: '1',
      content: 'How are you doing',
    ),

    Message(
      id: '2',
      sender: '1',
      receiver: '3',
      content: 'Hi',
    ),
    Message(
      id: '5',
      sender: '3',
      receiver: '1',
      content: 'Hello',
    ),
  ];

  @override
  Future<List<Message?>?> getMessages() async {
    return messages;
  }

  @override
  Future<void> saveMessage(Message message) async {
    messageStorage.saveMessage(message);
  }
}
