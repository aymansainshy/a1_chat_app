import '../../../config/app_config.dart';
import '../../../modules/messages/models/message.dart';
import '../../../modules/storage/storage.dart';
import '../../online-users/models/user_model.dart';

abstract class MessageRepository {
  Future<List<Message?>?> getMessages();

  Future<void> saveMessage(Message message);
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
  };

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
