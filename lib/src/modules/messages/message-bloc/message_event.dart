part of 'message_bloc.dart';

abstract class MessageBlocEvent extends Equatable {
  const MessageBlocEvent();

  @override
  List<Object> get props => [];
}

class GetMessagesRoom extends MessageBlocEvent {}

class SendMessage extends MessageBlocEvent {
  // final Message message;

  // const SendMessage([this.message);
}

class ReceiveMessage extends MessageBlocEvent {
  final Message message;

  const ReceiveMessage(this.message);
}
