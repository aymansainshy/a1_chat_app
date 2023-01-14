part of 'message_bloc.dart';

// abstract class MessageBlocState extends Equatable {
//   const MessageBlocState();

//   @override
//   List<Object> get props => [];
// }

// class MessageBlocInitial extends MessageBlocState {}

class MessageBlocState {
  final Map<String, MessageRoom>? messageRooms;

  MessageBlocState({
    this.messageRooms,
  });

  MessageBlocState copyWith({Map<String, MessageRoom>? messageRooms}) {
    return MessageBlocState(
      messageRooms: messageRooms ?? this.messageRooms,
    );
  }
}
