import 'package:a1_chat_app/src/modules/messages/views/chat_view.dart';
import 'package:flutter/material.dart';

import '../../home/widgets/user_avatar.dart';
import '../models/message.dart';

class RoomWidget extends StatelessWidget {
  const RoomWidget({Key? key, required this.messageRoom}) : super(key: key);
  final MessageRoom messageRoom;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: ((context) => ChatView(messageRoom: messageRoom)),
          ),
        );
      },
      child: SizedBox(
        height: 85,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(
            children: [
              UserAvatar(imageUrl: messageRoom.imageUrl, isOnline: true),
              const SizedBox(width: 10),
              Expanded(
                child: Transform.translate(
                  offset: const Offset(0, 4),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${messageRoom.name ?? messageRoom.phoneNumber}",
                        style:
                            Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontSize: 18,
                                ),
                      ),
                      const SizedBox(height: 7),
                      Expanded(
                        child: Text(
                          "hi how are you .I am looking for something thitjrle l ... ",
                          style: Theme.of(context)
                              .textTheme
                              .caption
                              ?.copyWith(fontSize: 13),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Transform.translate(
                offset: const Offset(0, 4),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      "5 min",
                      style: Theme.of(context)
                          .textTheme
                          .caption
                          ?.copyWith(fontSize: 13),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      height: 22,
                      width: 22,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Theme.of(context).primaryColor),
                      child: Center(
                        child: Text(
                          '1',
                          style: Theme.of(context)
                              .textTheme
                              .bodyText1
                              ?.copyWith(color: Theme.of(context).cardColor),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
