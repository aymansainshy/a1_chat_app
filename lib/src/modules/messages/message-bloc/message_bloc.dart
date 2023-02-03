import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../config/app_config.dart';
import '../../online-users/models/user_model.dart';
import '../../socket-Io/socket_io.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:a1_chat_app/src/modules/messages/models/message.dart';
import 'package:a1_chat_app/src/modules/messages/repository/messages_repository.dart';

part 'message_event.dart';

part 'message_state.dart';

class MessageBloc extends Bloc<MessageBlocEvent, MessageBlocState> {
  final MessageRepository messageRepository;
  final SocketIO _socketIO;
  late String? openedRoom = '';

  final Map<String, MessageRoom?> _messageRooms = {};

  User? getRoomUser(Message message) {
    bool isMe = message.sender?.phoneNumber == Application.user?.phoneNumber;
    return isMe ? message.receiver : message.sender;
  }

  MessageBloc(this._socketIO, this.messageRepository) : super(MessageBlocState(messageRooms: {})) {
    on<OpenMessagesRoom>((event, emit) {
      openedRoom = event.openedRoom;
    });

    on<GetMessagesRoom>((event, emit) async {
      final loadedMessageRooms = messageRepository.getMessages();

      // loadedMessageRooms?.sort((e1, e2) => e1!.receivedAt!.compareTo(e2!.receivedAt!));

      for (var message in loadedMessageRooms!) {
        final roomUser = getRoomUser(message!);

        if (_messageRooms.containsKey(roomUser!.phoneNumber)) {
          _messageRooms[roomUser.phoneNumber]?.messages.add(message);
        } else {
          _messageRooms.putIfAbsent(roomUser.phoneNumber!, () {
            final createdRoom = MessageRoom(
              id: message.receiver?.id,
              user: roomUser,
              messages: [message],
            );
            return createdRoom;
          });
        }
      }

      emit(state.copyWith(messageRooms: _messageRooms));
    });

    on<SendMessage>((event, emit) {
      if (_messageRooms.containsKey(event.message?.receiver?.phoneNumber)) {
        _messageRooms[event.message?.receiver?.phoneNumber]?.messages.add(event.message!);

        _socketIO.sendMessage(event.message!);

        emit(state.copyWith(messageRooms: _messageRooms));
        messageRepository.saveMessage(event.message!);
      } else {
        _messageRooms.putIfAbsent(event.message!.receiver!.phoneNumber!, () {
          final createdRoom = MessageRoom(
            id: event.message?.receiver?.id,
            user: event.message?.receiver,
            messages: [event.message!],
          );
          return createdRoom;
        });

        _socketIO.sendMessage(event.message!);
        emit(state.copyWith(messageRooms: _messageRooms));
        messageRepository.saveMessage(event.message!);
      }
    });

    on<MessageSuccess>((event, emit) {
      final messages = _messageRooms[event.message.receiver?.phoneNumber]?.messages;
      final message = messages?.firstWhere((message) => message.id == event.message.id);
      final messageIndex = messages?.indexOf(message!);
      message?.isReceive = true;

      messages?.removeAt(messageIndex!);
      messages?.insert(messageIndex!, message!);

      _messageRooms[event.message.receiver?.phoneNumber]?.messages = messages!;
      messageRepository.saveMessage(message!);
      emit(state.copyWith(messageRooms: _messageRooms));
    });

    //Receive new message
    on<ReceiveMessage>((event, emit) {
      if (_messageRooms.containsKey(event.message.sender?.phoneNumber)) {
        if (openedRoom == event.message.sender?.phoneNumber) {
          event.message.isNew = false;
          _socketIO.iReadMessages(event.message);
          messageRepository.saveMessage(event.message);
        }

        _messageRooms[event.message.sender?.phoneNumber]?.messages.add(event.message);
        _socketIO.messageDelivered(event.message);
        messageRepository.saveMessage(event.message);
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
        _socketIO.messageDelivered(event.message);
        messageRepository.saveMessage(event.message);
        emit(state.copyWith(messageRooms: _messageRooms));
      }
    });

    // Message Delivered to user
    on<MessageDelivered>((event, emit) {
      final messages = _messageRooms[event.message.receiver?.phoneNumber]?.messages;
      final message = messages?.firstWhere((message) => message.id == event.message.id);
      final messageIndex = messages?.indexOf(message!);
      message?.isDelivered = true;

      messages?.removeAt(messageIndex!);
      messages?.insert(messageIndex!, message!);
      _messageRooms[event.message.receiver?.phoneNumber]?.messages = messages!;
      messageRepository.saveMessage(message!);
      emit(state.copyWith(messageRooms: _messageRooms));
    });

    on<IReadMessage>((event, emit) {
      if (event.message.sender == Application.user) {
        return;
      }
      _socketIO.iReadMessages(event.message);

      for (var message in _messageRooms[event.message.sender?.phoneNumber]!.messages) {
        message.isNew = false;
        messageRepository.saveMessage(message);
      }

      emit(state.copyWith(messageRooms: _messageRooms));
    });

    on<MessageRead>((event, emit) {
      for (var message in _messageRooms[event.message.receiver?.phoneNumber]!.messages) {
        message.isRead = true;
        messageRepository.saveMessage(message);
      }
      emit(state.copyWith(messageRooms: _messageRooms));
    });
  }
}
