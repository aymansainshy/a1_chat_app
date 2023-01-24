part of 'message_bloc.dart';

class MessageBlocState {
  final Map<String, MessageRoom?> messageRooms;

  int unReadedMessage(MessageRoom room) {
    final messages = messageRooms[room.user?.phoneNumber]
        ?.messages
        ?.where((message) => !message!.isRead);
    return messages?.length ?? 0;
  }

  MessageBlocState({
    required this.messageRooms,
  });

  MessageBlocState copyWith(
      {Map<String, MessageRoom?>? messageRooms, MessageRoom? room}) {
    return MessageBlocState(
      messageRooms: messageRooms ?? this.messageRooms,
    );
  }
}
