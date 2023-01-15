import '../../../modules/messages/models/message.dart';
import '../../../modules/storage/storage.dart';

abstract class MessageRepository {
  Future<Map<String, MessageRoom>?> getMessages();

  Future<void> saveMessage(MessageRoom messageRoom);
}

class MessageRepositoryImpl extends MessageRepository {
  final Storage messageStorage;

  MessageRepositoryImpl(this.messageStorage);
  final Map<String, MessageRoom>? messagesWithRooms = const {
    '1': MessageRoom(
      id: '1',
      name: 'Ayman',
      phoneNumber: '+249924081893',
      imageUrl: 'https://i.kinja-img.com/gawker-media/image/upload/t_original/ijsi5fzb1nbkbhxa2gc1.png',
      messages: [
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
          content: 'Hello, whats up',
        ),
      ],
    ),
    '2': MessageRoom(
      id: '2',
      name: 'Sainshy',
      phoneNumber: '+249922222222',
      imageUrl: 'https://im.indiatimes.in/content/2022/Feb/AMP-44_61fb8b8840826.jpg?w=1200&h=900&cc=1',
      messages: [
        Message(
          id: '2',
          sender: '2',
          receiver: '10',
          content: 'Hello',
        ),
        Message(
          id: '5',
          sender: '1',
          receiver: '10',
          content: 'Hi',
        ),
      ],
    ),
  };

  @override
  Future<Map<String, MessageRoom>?> getMessages() async {
    return messagesWithRooms;
  }

  @override
  Future<void> saveMessage(MessageRoom messageRoom) async {
    messageStorage.saveMessage(messageRoom);
  }
}
