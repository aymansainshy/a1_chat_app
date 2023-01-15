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
        height: 90,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
          child: Row(
            children: [
              UserAvatar(imageUrl: messageRoom.imageUrl, isOnline: true, radius: 30),
              const SizedBox(width: 10),
              Expanded(
                child: Transform.translate(
                  offset: const Offset(0, 4.5),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              "${messageRoom.name ?? messageRoom.phoneNumber}",
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(
                                    fontSize: 18,
                                  ),
                            ),
                          ),
                          Text(
                            "5 min",
                            style:
                                Theme.of(context).textTheme.caption?.copyWith(
                                      color: Theme.of(context).primaryColor,
                                    ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 2),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              "hi how are you .I am looking for something can you help me ?... ",
                              style: Theme.of(context)
                                  .textTheme
                                  .caption
                                  // ?.copyWith(fontSize: 12),
                            ),
                          ),
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
                                    .bodyText2
                                    ?.copyWith(
                                        color: Theme.of(context).cardColor),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
