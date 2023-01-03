part of 'message_bloc.dart';

// abstract class MessageBlocState extends Equatable {
//   const MessageBlocState();

//   @override
//   List<Object> get props => [];
// }

// class MessageBlocInitial extends MessageBlocState {}

class MessageBlocState {
  final Map<MessageRoom, List<Message?>?>? messages;

  MessageBlocState({
    this.messages,
  });

  MessageBlocState copyWith({Map<MessageRoom, List<Message?>?>? messages}) {
    return MessageBlocState(
      messages: messages ?? this.messages,
    );
  }
}
