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
      if (_messageRooms.containsKey(event.room?.user?.phoneNumber)) {
        _messageRooms[event.room?.user?.phoneNumber]?.messages?.add(event.message);
        _socketIO.sendMessage(event.message!);
        emit(state.copyWith(messageRooms: _messageRooms));

      } else {
        _messageRooms.putIfAbsent(event.room!.user!.phoneNumber!, () {
          final createdRoom = MessageRoom(
            id: event.room?.id,
            user: event.room?.user,
            messages: [event.message],
          );
          return createdRoom;
        });

        _socketIO.sendMessage(event.message!);
        emit(state.copyWith(messageRooms: _messageRooms));
      }
    });

    on<ReceiveMessage>((event, emit) {
      // Room should be with sender
    });
  }
}
