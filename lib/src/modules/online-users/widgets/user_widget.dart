import 'package:a1_chat_app/src/modules/messages/models/message.dart';
import 'package:a1_chat_app/src/modules/online-users/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../home/widgets/user_avatar.dart';

class OnlineUserWidget extends StatelessWidget {
  const OnlineUserWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        // Create Room on the fly .........
        final messageRoom = MessageRoom(
          id: "+249912345678",
          user: User(
            id: '20',
            phoneNumber: "+249912345678",
            imageUrl:
                "https://im.indiatimes.in/content/2022/Feb/AMP-44_61fb8b8840826.jpg?w=1200&h=900&cc=1",
          ),
        );
        context.go('/chat', extra: messageRoom);
      },
      child: SizedBox(
        height: 80,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
          child: Row(
            children: [
              const UserAvatar(
                imageUrl:
                    "https://im.indiatimes.in/content/2022/Feb/AMP-44_61fb8b8840826.jpg?w=1200&h=900&cc=1",
                isOnline: true,
                radius: 26,
              ),
              const SizedBox(width: 8),
              Transform.translate(
                offset: const Offset(0, 0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Jhone Cena",
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium
                          ?.copyWith(fontSize: 20),
                    ),
                    // const SizedBox(height: 8),
                    // Transform.translate(
                    //   offset: const Offset(0, -5),
                    //   child: Text(
                    //     "Online",
                    //     style: Theme.of(context).textTheme.bodyText2,
                    //   ),
                    // ),
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
