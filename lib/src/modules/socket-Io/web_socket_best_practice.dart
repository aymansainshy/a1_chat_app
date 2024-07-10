import 'package:a1_chat_app/src/app/app_config_model.dart';
import 'package:a1_chat_app/src/modules/messages/models/message.dart';
import 'package:a1_chat_app/src/modules/online-users/models/user_model.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;

abstract class WebSocket {
  const WebSocket();

  io.Socket connect();

  io.Socket getIO();

  // List<User> getConnectedUsers();

  void dispose();
}

// @Singleton
// @Injectable
class WebSocketClient extends WebSocket {
  late io.Socket _socket;
  bool isConnect = false;

  WebSocketClient() {
    connect();
  }

  @override
  io.Socket connect() {
    if (isConnect) {
      return _socket;
    }

    _socket = io.io(
      'http://192.168.43.104:3333/',
      <String, dynamic>{
        'transports': ['websocket'],
        'autoConnect': true,
      },
    );

    _socket.onConnect((_) {
      isConnect = true;
      print("Connected .........");
      return _socket.emit('user-connected', {'user': Application.user?.toJson()});
    });

    _socket.onDisconnect((_) => print('disconnect'));

    return _socket;
  }

  @override
  io.Socket getIO() {
    if (isConnect) {
      return _socket;
    } else {
      return connect();
    }
  }

  // Wherever you call connect function, you should call dispose too.
  @override
  void dispose() {
    _socket.disconnect();
    _socket.dispose();
    isConnect = false;
  }
}

abstract class MessageSocket {
  const MessageSocket();

  void listenToEvents();

  void iReadMessages(Message event);

  void sendMessage(Message message);

  void messageDelivered(Message message);

  void typing(String senderPhone, String receiverPhone);
}

class MessageSocketImpl extends MessageSocket {
  final WebSocket _socketClient = WebSocketClient();
  late io.Socket _socket;

  MessageSocketImpl() {
    _socket = _socketClient.getIO();
    listenToEvents();
  }

  @override
  void listenToEvents() {
    _socket.on("message", (data) => broadcastMessageToListener(data));
  }

  // User StreamSubscriptions to listen to upcoming messages (events)
  Stream<String> broadcastMessageToListener(String message) async* {
    yield message;
  }


  @override
  void iReadMessages(Message message) {
    _socket.emit('iread-message', message.toJson());
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
  void typing(String senderPhone, String receiverPhone) {
    _socket.emit('typing', {
      'senderPhone': senderPhone,
      'receiverPhone': receiverPhone,
    });
  }
}
