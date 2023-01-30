part of 'message_bloc.dart';

class MessageBlocState {
  final Map<String, MessageRoom?> messageRooms;

  int newMessages(MessageRoom room) {
    final messages = messageRooms[room.user?.phoneNumber]?.messages.where(
        (message) => message.isNew && message.receiver == Application.user);
    return messages?.length ?? 0;
  }

  int totalNewMessages() {
    int total = 0;
    messageRooms.forEach((key, message) {
      var count = newMessages(messageRooms[key]!);
      total = total + count;
    });
    return total;
  }

  MessageBlocState({
    required this.messageRooms,
  });

  MessageBlocState copyWith({Map<String, MessageRoom?>? messageRooms, MessageRoom? room}) {
    return MessageBlocState(
      messageRooms: messageRooms ?? this.messageRooms,
    );
  }
}
