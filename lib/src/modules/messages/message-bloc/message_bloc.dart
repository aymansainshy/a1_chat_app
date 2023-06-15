import 'package:a1_chat_app/injector.dart';
import 'package:a1_chat_app/src/modules/messages/message-bloc/single_message_bloc/single_message_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../app/app_config_model.dart';
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

    on<FetchUserMessages>((event, emit) async {
     try {
        await messageRepository.fetchUserMessages();
      } catch (e) {
        if (kDebugMode) print(e.toString());
      }
    });

    on<FetchUserReceivedMessages>((event, emit) async {
      List<Message?> loadedUserMessages = await messageRepository.fetchUserReceivedMessages();
      try {
        for (var message in loadedUserMessages) {
          if (kDebugMode) print("message ID ...... ${message!.id}");

          if (_messageRooms.containsKey(message!.sender?.phoneNumber)) {
            if (!_messageRooms[message.sender?.phoneNumber]!.messages.contains(message)) {
              _messageRooms[message.sender?.phoneNumber]!.messages.add(message);

              if (message.messageType == MessageType.media) {
                injector<SingleMessageBloc>().add(DownloadMessageFiles(message));
              }
            }
          } else {
            _messageRooms.putIfAbsent(message.sender!.phoneNumber!, () {
              final createdRoom = MessageRoom(
                id: message.sender?.id,
                user: message.sender,
                messages: [message],
              );
              return createdRoom;
            });

            if (message.messageType == MessageType.media) {
              injector<SingleMessageBloc>().add(DownloadMessageFiles(message));
            }
          }

          emit(state.copyWith(messageRooms: _messageRooms));
          message.isDelivered = true;
          _socketIO.messageDelivered(message); // emit socket event
          messageRepository.saveMessage(message);
        }
      } catch (e) {
        if (kDebugMode) print(e.toString());
      }
    });

    // Emit bloc event to emit socket event - Send-Message
    on<SendTextMessage>((event, emit) {
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

    on<SendFileMessage>((event, emit) async {
      if (_messageRooms.containsKey(event.message?.receiver?.phoneNumber)) {
        _messageRooms[event.message?.receiver?.phoneNumber]?.messages.add(event.message!);

        injector<SingleMessageBloc>().add(SendMessageFiles(event.message!));
        emit(state.copyWith(messageRooms: _messageRooms));
      } else {
        _messageRooms.putIfAbsent(event.message!.receiver!.phoneNumber!, () {
          final createdRoom = MessageRoom(
            id: event.message?.receiver?.id,
            user: event.message?.receiver,
            messages: [event.message!],
          );
          return createdRoom;
        });

        injector<SingleMessageBloc>().add(SendMessageFiles(event.message!));
        emit(state.copyWith(messageRooms: _messageRooms));
      }
    });

    // Listen to socket event - message-success
    on<MessageSuccess>((event, emit) {
      for (var message in _messageRooms[event.message.receiver?.phoneNumber!]!.messages) {
        if (message.uuid == event.message.uuid) {
          message.isSuccess = true;
          messageRepository.saveMessage(message);
          emit(state.copyWith(messageRooms: _messageRooms));
          return;
        }
      }
    });

    // Listen to socket event - Receive new message
    on<ReceiveMessage>((event, emit) {
      if (_messageRooms.containsKey(event.message.sender?.phoneNumber)) {
        // If the user is already in the room ,
        // message should be delivered and read .
        if (openedRoom == event.message.sender?.phoneNumber) {
          event.message.isNew = false;
          event.message.isDelivered = true;
          event.message.isRead = true;
          _socketIO.iReadMessages(event.message); // emit socket event
          messageRepository.saveMessage(event.message);
        }

        _messageRooms[event.message.sender?.phoneNumber]?.messages.add(event.message);
        event.message.isDelivered = true;
        _socketIO.messageDelivered(event.message); // emit socket event
        messageRepository.saveMessage(event.message);

        emit(state.copyWith(messageRooms: _messageRooms));

        if (event.message.messageType == MessageType.media) {
          injector<SingleMessageBloc>().add(DownloadMessageFiles(event.message));
        }
      } else {
        _messageRooms.putIfAbsent(event.message.sender!.phoneNumber!, () {
          final createdRoom = MessageRoom(
            id: event.message.sender?.id,
            user: event.message.sender,
            messages: [event.message],
          );
          return createdRoom;
        });

        event.message.isDelivered = true;
        _socketIO.messageDelivered(event.message); // emit socket event
        messageRepository.saveMessage(event.message);
        emit(state.copyWith(messageRooms: _messageRooms));

        if (event.message.messageType == MessageType.media) {
          injector<SingleMessageBloc>().add(DownloadMessageFiles(event.message));
        }
      }
    });

    // Listen to socket event - Message Delivered to user
    on<MessageDelivered>((event, emit) {
      for (var message in _messageRooms[event.message.receiver?.phoneNumber!]!.messages) {
        if (message.uuid == event.message.uuid) {
          message.isDelivered = true;
          messageRepository.saveMessage(message);
          emit(state.copyWith(messageRooms: _messageRooms));
          return;
        }
      }
    });

    // emit Bloc event to emit socket event
    on<IReadMessage>((event, emit) {
      if (event.message.sender == Application.user) {
        return;
      }

      event.message.isRead = true;

      for (var message in _messageRooms[event.message.sender?.phoneNumber]!.messages) {
        message.isNew = false;
        messageRepository.saveMessage(message);
      }
      _socketIO.iReadMessages(event.message); // emit socket event

      emit(state.copyWith(messageRooms: _messageRooms));
    });

    // Listen to socket event - message-read
    on<MessageRead>((event, emit) {
      for (var message in _messageRooms[event.message.receiver?.phoneNumber]!.messages) {
        message.isRead = true;
        messageRepository.saveMessage(message);
      }
      emit(state.copyWith(messageRooms: _messageRooms));
    });
  }
}
