import 'package:a1_chat_app/src/modules/messages/models/message.dart';
import 'package:a1_chat_app/src/modules/storage/storage.dart';

abstract class MessageRepository {
  Future<List<Message?>?> getMessages();

  Future<MessageRoom?> getMessageRoom(String roomId);

  Future<void> saveMessage(Message message);
}

class MessageRepositoryImpl extends MessageRepository {
  final MessageStorageImpl messageStorage;

  MessageRepositoryImpl(this.messageStorage);

  final List<Message?>? messages = [
    Message(
      id: '1',
      sender: '1',
      receiver: '10',
      content: 'Hello',
    ),
    Message(
      id: '1',
      sender: '1',
      receiver: '3',
      content: 'Hi',
    ),
    Message(
      id: '1',
      sender: '10',
      receiver: '1',
      content: 'Hello',
    ),
    Message(
      id: '1',
      sender: '10',
      receiver: '1',
      content: 'How are you doing',
    ),
    Message(
      id: '1',
      sender: '3',
      receiver: '',
      content: 'Hello',
    ),
  ];

  @override
  Future<List<Message?>?> getMessages() async {
    return messages;
  }

  @override
  Future<MessageRoom?> getMessageRoom(String roomId) {
    // TODO: implement getMessageRoom
    throw UnimplementedError();
  }

  @override
  Future<void> saveMessage(Message message) async {
    messageStorage.saveMessage(message);
  }
}
