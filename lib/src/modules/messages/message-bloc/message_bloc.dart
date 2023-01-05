import 'package:a1_chat_app/src/modules/messages/models/message.dart';
import 'package:a1_chat_app/src/modules/messages/repository/messages_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../socket-Io/socket_io.dart';

part 'message_event.dart';

part 'message_state.dart';

class MessageBloc extends Bloc<MessageBlocEvent, MessageBlocState> {
  final MessageRepository messageRepository;
  final SocketIO _socketIO;

  late bool isMe;

  final Map<MessageRoom, List<Message?>?>? messages = {};

  MessageBloc(
    this._socketIO,
    this.messageRepository,
  ) : super(MessageBlocState(messages: {})) {

    on<GetMessages>((event, emit) async {
      List<Message?>? loadedMessages = await messageRepository.getMessages();

      loadedMessages?.forEach((message) {
        isMe = message?.sender == '1';

        if ((messages?.containsKey(MessageRoom(id: isMe ? message?.receiver : message?.sender)))!) {
          messages![MessageRoom(id: isMe ? message?.receiver : message?.sender)]?.add(message);
        } else {
          messages?.putIfAbsent(MessageRoom(id: isMe ? message?.receiver : message?.sender),() => [message]);
        }
      });

      // print("messages ${messages.toString()}");

      // final room = event.room;
      // final messages = messages[room];
      // if(messages != null) {
      // final messsage[room] = messages;
      // emit(newstate);
      // }
    });

    on<SendMessage>((event, emit) {
      _socketIO.sendMessage(
        const Message(
          id: '445',
          sender: '1',
          receiver: '10',
          content: 'Hello Server',
        ),
      );
      // final message = event.message;
      // if ((messages?.containsKey(MessageRoom(id: message.id)))!) {
      //   messages![MessageRoom(id: message.id)]?.add(message);
      //   // Send message to server
      // } else {
      //   messages?.putIfAbsent(MessageRoom(id: message.id), () => [message]);
      //   // Send message to server
      // }
    });

    on<ReceiveMessage>((event, emit) {
      // Receive message from server
      final message = event.message;
      if ((messages?.containsKey(MessageRoom(id: message.id)))!) {
        messages![MessageRoom(id: message.id)]?.add(message);
      } else {
        messages?.putIfAbsent(MessageRoom(id: message.id), () => [message]);
      }
    });
  }
}
