import '../../../config/app_config.dart';
import '../../../modules/messages/models/message.dart';
import '../../../modules/storage/storage.dart';
import '../../online-users/models/user_model.dart';

abstract class MessageRepository {
  Future<Map<String, MessageRoom?>?> getMessages();

  Future<void> saveMessage(MessageRoom messageRoom);
}

class MessageRepositoryImpl extends MessageRepository {
  final Storage messageStorage;

  MessageRepositoryImpl(this.messageStorage);

  final Map<String, MessageRoom?> messagesWithRooms = {
    '+24992222222': MessageRoom(
      id: '+24992222222',
      user: User(
        id: '2',
        imageUrl: 'clcow8vds0001ialq2gy652v6.png',
        phoneNumber: '+24992222222',
      ),
      messages: [
        Message(
          id: DateTime.now().toIso8601String(),
          sender: Application.user,
          receiver: User(
            id: '2',
            imageUrl: 'clcow8vds0001ialq2gy652v6.png',
            phoneNumber: '+24992222222',
          ),
          content: 'Hello',
          createdAt: DateTime.now(),
        ),
        Message(
          id: DateTime.now().toIso8601String(),
          sender: User(
            id: '2',
            imageUrl: 'clcow8vds0001ialq2gy652v6.png',
            phoneNumber: '+24992222222',
          ),
          receiver: Application.user,
          createdAt: DateTime.now(),
          content: 'Hello, whats up , I am doing well! ',
        ),
        Message(
          id: DateTime.now().toIso8601String(),
          sender: User(
            id: '2',
            imageUrl: 'clcow8vds0001ialq2gy652v6.png',
            phoneNumber: '+24992222222',
          ),
          receiver: Application.user,
          createdAt: DateTime.now(),
          content:
              'Most of us are familiar with the concept of constructors ,They allow us to create different instances of our classes. ',
        ),
      ],
    ),
    // '+249911111111': MessageRoom(
    //   id: '2',
    //   name: 'Mohammed',
    //   phoneNumber: '+249911111111',
    //   imageUrl: 'https://im.indiatimes.in/content/2022/Feb/AMP-44_61fb8b8840826.jpg?w=1200&h=900&cc=1',
    //   messages: [
    //     Message(
    //       id: '2',
    //       sender: '+249911111111',
    //       receiver: '+249924081893',
    //       content: 'Hello',
    //     ),
    //     Message(
    //       id: '5',
    //       sender: '+249924081893',
    //       receiver: '+249911111111',
    //       content: 'Hi',
    //     ),
    //   ],
    // ),
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
