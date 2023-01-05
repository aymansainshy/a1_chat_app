import 'package:socket_io_client/socket_io_client.dart' as io;

abstract class SocketIO {
  void connect();
  void dispose();
}

class SocketIoImpl extends SocketIO {
  late  io.Socket _socket;

  @override
  void connect() {
     _socket = io.io('http://localhost:3000');
    print('Start connect');

    _socket.onConnect((_) {
      print('connect');
      _socket.emit('msg', 'test');
    });

    _socket.on('event', (data) => print(data));

    _socket.on('send', (data) => print(data));

    _socket.onDisconnect((_) => print('disconnect'));

    _socket.on('fromServer', (_) => print(_));
  }


  @override
  void dispose() {
    _socket.disconnect();
    _socket.dispose();
  }
}
