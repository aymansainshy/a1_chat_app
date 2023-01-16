part of 'message_bloc.dart';

abstract class MessageBlocEvent extends Equatable {
  const MessageBlocEvent();

  @override
  List<Object> get props => [];
}

class GetMessagesRoom extends MessageBlocEvent {}

class SendMessage extends MessageBlocEvent {
  final MessageRoom? room;
  final Message? message;

  const SendMessage({required this.message, required this.room});
}

class ReceiveMessage extends MessageBlocEvent {
  final String? roomId;
  final Message message;

  const ReceiveMessage({required this.message, this.roomId});
}
