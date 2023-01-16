import 'package:socket_io_client/socket_io_client.dart' as io;

import '../auth/model/user.dart';
import '../messages/models/message.dart';

abstract class SocketIO {
  void connectAndListen();

  void sendMessage(Message message);

  void messageRead(String messageId, String recieverId);

  void typing(String senderId, String recieverId);

  void stopTyping(String senderId, String recieverId);

  void userDataChanged(User user);

  void dispose();
}

class SocketIoImpl extends SocketIO {
  late io.Socket _socket;

  Map<String, String> data = {"data": 'Data from cleint'};

  @override
  void connectAndListen() {
    _socket = io.io('http://192.168.43.104:3333/', <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': true,
    });

    _socket.onConnect((_) {
      print('Socket connected...');
    });

    _socket.emit('sendData', data);

    _socket.on('send', (data) => print(data));

    _socket.on('recieve-message', (data) => print(data));

    _socket.onDisconnect((_) => print('disconnect'));
  }

  @override
  void messageRead(String messageId, String recieverId) {
    _socket.emit('message-read', {
      'messageId': messageId,
      'recieverId': recieverId,
    });
  }

  @override
  void sendMessage(Message message) {
    final messageData = {
      'id': message.id,
      'sender': message.sender,
      'receiver': message.receiver,
      'content': message.content,
    };
    _socket.emit('sendMessage', messageData);
  }

  @override
  void typing(String senderId, String recieverId) {
    _socket.emit('typing', {
      'senderId': senderId,
      'recieverId': recieverId,
    });
  }

  @override
  void stopTyping(String senderId, String recieverId) {
    _socket.emit('stop-typing', {
      'senderId': senderId,
      'recieverId': recieverId,
    });
  }

  @override
  void userDataChanged(User user) {
    _socket.emit('user-change-data', {'user': user});
  }

  @override
  void dispose() {
    _socket.disconnect();
    _socket.dispose();
  }
}
