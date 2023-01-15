import '../../../modules/messages/models/message.dart';
import '../../../modules/storage/storage.dart';

abstract class MessageRepository {
  Future<Map<String, MessageRoom?>?> getMessages();

  Future<void> saveMessage(MessageRoom messageRoom);
}

class MessageRepositoryImpl extends MessageRepository {
  final Storage messageStorage;

  MessageRepositoryImpl(this.messageStorage);

  final Map<String, MessageRoom?> messagesWithRooms = {
    '+24992222222':  MessageRoom(
      id: '1',
      name: 'Sainshy',
      phoneNumber: '+24992222222',
      imageUrl:
          'https://i.kinja-img.com/gawker-media/image/upload/t_original/ijsi5fzb1nbkbhxa2gc1.png',
      messages:  [
        Message(
          id: '1',
          sender: '+249924081893',
          receiver: '+24992222222',
          content: 'Hello',
        ),
        Message(
          id: '3',
          sender: '+24992222222',
          receiver: '+249924081893',
          content: 'Hello, whats up',
        ),
      ],
    ),
    '+249911111111': MessageRoom(
      id: '2',
      name: 'Mohammed',
      phoneNumber: '+249911111111',
      imageUrl: 'https://im.indiatimes.in/content/2022/Feb/AMP-44_61fb8b8840826.jpg?w=1200&h=900&cc=1',
      messages: [
        Message(
          id: '2',
          sender: '+249911111111',
          receiver: '+249924081893',
          content: 'Hello',
        ),
        Message(
          id: '5',
          sender: '+249924081893',
          receiver: '+249911111111',
          content: 'Hi',
        ),
      ],
    ),
  };

  @override
  Future<Map<String, MessageRoom?>?> getMessages() async {
    return messagesWithRooms;
  }

  @override
  Future<void> saveMessage(MessageRoom messageRoom) async {
    messageStorage.saveMessage(messageRoom);
  }
}
