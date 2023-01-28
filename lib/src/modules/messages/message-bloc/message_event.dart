part of 'message_bloc.dart';

abstract class MessageBlocEvent extends Equatable {
  const MessageBlocEvent();

  @override
  List<Object> get props => [];
}

class GetMessagesRoom extends MessageBlocEvent {}

class OpenMessagesRoom extends MessageBlocEvent {
  final String openedRoom;

  const OpenMessagesRoom(this.openedRoom);
}

class SendMessage extends MessageBlocEvent {
  // final MessageRoom? room;
  final Message? message;

  const SendMessage({required this.message});
}

class ReceiveMessage extends MessageBlocEvent {
  final Message message;

  const ReceiveMessage({required this.message});
}

class MessageSuccess extends MessageBlocEvent {
  final Message message;

  const MessageSuccess({required this.message});
}

class MessageDelivered extends MessageBlocEvent {
  final Message message;

  const MessageDelivered({required this.message});
}

class MessageRead extends MessageBlocEvent {
  final Message message;

  const MessageRead({required this.message});
}

class IReadMessage extends MessageBlocEvent {
  final Message message;

  const IReadMessage({required this.message});
}
