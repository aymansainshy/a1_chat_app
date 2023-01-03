import 'package:a1_chat_app/src/modules/messages/models/message.dart';
import 'package:a1_chat_app/src/modules/messages/repository/messages_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'message_event.dart';
part 'message_state.dart';

class MessageBloc extends Bloc<MessageBlocEvent, MessageBlocState> {
  final MessageRepositoryImpl messageRepository;

  final Map<MessageRoom, List<Message?>?>? messages = {};

  MessageBloc(this.messageRepository) : super(MessageBlocState(messages: {})) {
    on<GetMessages>((event, emit) async {
      List<Message?>? loadedMessages = await messageRepository.getMessages();

      loadedMessages?.map((message) {
        if ((messages?.containsKey(MessageRoom(id: message?.id)))!) {
          messages![MessageRoom(id: message?.id)]?.add(message);
        } else {
          messages?.putIfAbsent(MessageRoom(id: message?.id), () => [message]);
        }
      });
    });

    on<SendMessage>((event, emit) {
      final message = event.message;
      if ((messages?.containsKey(MessageRoom(id: message.id)))!) {
        messages![MessageRoom(id: message.id)]?.add(message);
        // Send message to server
      } else {
        messages?.putIfAbsent(MessageRoom(id: message.id), () => [message]);
        // Send message to server
      }
    });

    on<ReceiveMessage>((event, emit) {
      // Receive message from server
      final message = event.message;
      if ((messages?.containsKey(MessageRoom(id: message.id)))!) {
        messages![MessageRoom(id: message.id)]?.add(message);
      } else {
        messages?.putIfAbsent(MessageRoom(id: message.id), () => [message]);
      }
    });
  }
}
