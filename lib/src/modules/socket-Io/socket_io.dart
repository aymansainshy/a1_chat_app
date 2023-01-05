import 'package:socket_io_client/socket_io_client.dart' as io;

abstract class SocketIO {
  void connectAndListen();
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
      _socket.emit('sendData', data);
    });

    _socket.on('send', (data) => print(data));

    _socket.onDisconnect((_) => print('disconnect'));
  }


  @override
  void dispose() {
    _socket.disconnect();
    _socket.dispose();
  }
}
