part of 'message_bloc.dart';

class MessageBlocState {
  final Map<String, MessageRoom?> messageRooms;

  MessageBlocState({
    required this.messageRooms,
  });

  MessageBlocState copyWith({Map<String, MessageRoom?>? messageRooms, MessageRoom? room}) {
    return MessageBlocState(
      messageRooms: messageRooms ?? this.messageRooms,
    );
  }
}
