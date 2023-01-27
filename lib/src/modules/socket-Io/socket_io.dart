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

  void messageDelivered(Message message);

  void iReadMessages(String senderPhone, String recieverPhone);

  void typing(String senderPhone, String recieverPhone);

  void stopTyping(String senderPhone, String recieverPhone);

  void userDataChanged(User user);

  void dispose();
}

class SocketIoImpl extends SocketIO {
  late io.Socket _socket;

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
      return _socket.emit('user-data', {'user': Application.user?.toJson()});
    });

    _socket.on('online-user', (data) {
      injector<OnlineUsersBloc>().add(NewUser(User.fromJson(data)));
    });

    _socket.on('message-success', (data) {
      print("Success Data .............");
      print(data);
      injector<MessageBloc>().add(MessageSuccess(message: Message.fromJson(data)));
    });

    _socket.on('message-delivered', (data) {
      print("Delivered Data .............");
      print(data);
      injector<MessageBloc>().add(MessageDelivered(message: Message.fromJson(data)));
    });

    _socket.on('message', (data) {
      injector<MessageBloc>().add(ReceiveMessage(message: Message.fromJson(data)));
    });

    _socket.on('message-read', (senderPhone) {
      injector<MessageBloc>().add(MessageRead(senderPhone: senderPhone));
    });

    _socket.onDisconnect((_) => print('disconnect'));
  }

  @override
  void iReadMessages(String senderPhone, String recieverPhone) {
    _socket.emit('iread-message', {
      'senderPhone': senderPhone,
      'recieverPhone': recieverPhone,
    });
  }

  @override
  void sendMessage(Message message) {
    _socket.emit('send-message', message.toJson());
  }

  @override
  void messageDelivered(Message message) {
    _socket.emit('message-delivered', message.toJson());
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
