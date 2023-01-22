import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../socket-Io/socket_io.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:a1_chat_app/src/modules/messages/models/message.dart';
import 'package:a1_chat_app/src/modules/messages/repository/messages_repository.dart';

part 'message_event.dart';

part 'message_state.dart';

class MessageBloc extends Bloc<MessageBlocEvent, MessageBlocState> {
  final MessageRepository messageRepository;
  final SocketIO _socketIO;

  // late bool isMe;
  Map<String, MessageRoom?> _messageRooms = {};

  MessageBloc(this._socketIO, this.messageRepository)
      : super(MessageBlocState(messageRooms: {})) {
    on<GetMessagesRoom>((event, emit) async {
      final loadedMessageRooms = await messageRepository.getMessages();
      _messageRooms = loadedMessageRooms!;
      emit(state.copyWith(messageRooms: _messageRooms));
    });

    on<SendMessage>((event, emit) {
      if (_messageRooms.containsKey(event.message?.receiver?.phoneNumber)) {
        _messageRooms[event.message?.receiver?.phoneNumber]
            ?.messages
            ?.add(event.message);

        _socketIO.sendMessage(event.message!);

        emit(state.copyWith(messageRooms: _messageRooms));
      } else {
        _messageRooms.putIfAbsent(event.message!.receiver!.phoneNumber!, () {
          final createdRoom = MessageRoom(
            id: event.message?.receiver?.id,
            user: event.message?.receiver,
            messages: [event.message],
          );
          return createdRoom;
        });

        _socketIO.sendMessage(event.message!);
        emit(state.copyWith(messageRooms: _messageRooms));
      }
    });

    on<ReceiveMessage>((event, emit) {
      if (_messageRooms.containsKey(event.message.sender?.phoneNumber)) {
        _messageRooms[event.message.sender?.phoneNumber]
            ?.messages
            ?.add(event.message);

        _socketIO.sendMessage(event.message);
        emit(state.copyWith(messageRooms: _messageRooms));
      } else {
        _messageRooms.putIfAbsent(event.message.sender!.phoneNumber!, () {
          final createdRoom = MessageRoom(
            id: event.message.sender?.id,
            user: event.message.sender,
            messages: [event.message],
          );
          return createdRoom;
        });
        emit(state.copyWith(messageRooms: _messageRooms));
      }
    });
  }
}
