import 'package:a1_chat_app/src/modules/messages/widgets/room_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../message-bloc/message_bloc.dart';

class MessagesRoomView extends StatelessWidget {
  const MessagesRoomView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MessageBloc, MessageBlocState>(
      builder: (context, messagesState) {
        return ListView.builder(
          itemCount: messagesState.messageRooms!.keys.length,
          itemBuilder: (context, i) {
            final messageRoom = messagesState.messageRooms!.values.toList();
            return RoomWidget(messageRoom: messageRoom[i]);
          },
        );
      },
    );
  }
}




// separatorBuilder: (BuildContext context, int index) => const Divider(
//   height: 0.5,
//   color: Colors.black,
// ),