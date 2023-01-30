
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

  void iReadMessages(Message message);

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
      return _socket.emit('user-connected', {'user': Application.user?.toJson()});
    });

    _socket.on('user-connected', (connectedUser) {
      injector<OnlineUsersBloc>().add(NewUser(User.fromJson(connectedUser)));
    });

    _socket.on('message-success', (message) {
      injector<MessageBloc>().add(MessageSuccess(message: Message.fromJson(message)));
    });

    _socket.on('message-delivered', (message) {
      injector<MessageBloc>().add(MessageDelivered(message: Message.fromJson(message)));
    });

    _socket.on('send-text-message', (textMessage) {
      injector<MessageBloc>().add(ReceiveMessage(message: Message.fromJson(textMessage)));
    });

    _socket.on('message-read', (message) {
      injector<MessageBloc>().add(MessageRead(message: Message.fromJson(message)));
    });

    _socket.on('disconnected-user', (disConnectedUser) {
      injector<OnlineUsersBloc>().add(UserDisconnected(User.fromJson(disConnectedUser)));
       print('disconnected-user $disConnectedUser');
    });

    _socket.onDisconnect((_) => print('disconnect'));
  }

  @override
  void iReadMessages(Message message) {
    _socket.emit('iread-message', message.toJson());
  }

  @override
  void sendMessage(Message message) {
    _socket.emit('send-text-message', message.toJson());
  }

  @override
  void messageDelivered(Message message) {
    _socket.emit('message-delivered', message.toJson());
  }

  @override
  void typing(String senderPhone, String recieverPhone) {
    _socket.emit('typing', {
      'senderPhone': senderPhone,
      'recieverPhone': recieverPhone,
    });
  }

  @override
  void stopTyping(String senderPhone, String recieverPhone) {
    _socket.emit('stop-typing', {
      'senderPhone': senderPhone,
      'recieverPhone': recieverPhone,
    });
  }

  @override
  void userDataChanged(User user) {
    _socket.emit('user-data-change', {'user': user});
  }

  @override
  void dispose() {
    _socket.disconnect();
    _socket.dispose();
  }
}
