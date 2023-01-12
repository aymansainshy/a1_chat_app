import 'package:a1_chat_app/src/modules/messages/widgets/room_widget.dart';
import 'package:flutter/material.dart';

class MessagesRoomList extends StatelessWidget {
  const MessagesRoomList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: 30,
      separatorBuilder: (BuildContext context, int index) => const Divider(
        height: 0.5,
        color: Colors.black,
      ),
      itemBuilder: (context, i) => const RoomWidget(),
    );
  }
}