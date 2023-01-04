import 'package:socket_io_client/socket_io_client.dart' as io;

abstract class SocketIO {
  void connect();
}

class SocketIoImpl extends SocketIO {
  @override
  void connect() {
    print('Start connect');
    io.Socket socket = io.io('http://127.0.0.1:3333');

    socket.onConnect((_) {
      print('connect');
      socket.emit('msg', 'test');
    });

    socket.on('event', (data) => print(data));

    socket.onDisconnect((_) => print('disconnect'));

    socket.on('fromServer', (_) => print(_));
  }
}
