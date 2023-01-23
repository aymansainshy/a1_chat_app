import 'dart:convert';

import 'package:a1_chat_app/injector.dart';
import 'package:a1_chat_app/src/modules/messages/message-bloc/message_bloc.dart';
import 'package:a1_chat_app/src/modules/online-users/online-users-bloc/online_users_bloc.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;

import '../../config/app_config.dart';
import '../messages/models/message.dart';
import '../online-users/models/user_model.dart';

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
    _socket = io.io(
      'http://192.168.43.104:3333/',
      <String, dynamic>{
        'transports': ['websocket'],
        'autoConnect': true,
      },
    );

    _socket.onConnect((_) {
      print('Socket connected...');
      return _socket.emit('user-data', {'user': Application.user?.toJson()});
    });

    // _socket.emit('user-data' , {'user': Application.user?.toJson()});
    // _socket.emit('sendData', data);

    _socket.on('online-user', (data) {
      injector<OnlineUsersBloc>().add(NewUser(User.fromJson(data)));
    });

    _socket.on(
        'recieve-message',
        (data) => injector<MessageBloc>().add(ReceiveMessage(
              message: Message.fromJson(jsonDecode(data)),
            )));

    _socket.onDisconnect((_) => print('disconnect'));
    // _socket.emit('disconnected-user-data', {'user': Application.user?.toJson()});}
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
    final messageData = messageConverter(message);
    _socket.emit('send-message', messageData);
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

Map<String, dynamic> messageConverter(Message message) {
  return {
    'id': message.id,
    'sender': {
      'id': message.sender?.id,
      'name': message.sender?.name,
      'phoneNumber': message.sender?.phoneNumber,
      'imageUrl': message.sender?.imageUrl,
    },
    'receiver': {
      'id': message.receiver?.id,
      'name': message.receiver?.name,
      'phoneNumber': message.receiver?.phoneNumber,
      'imageUrl': message.receiver?.imageUrl,
    },
    'content': message.content,
  };
}
