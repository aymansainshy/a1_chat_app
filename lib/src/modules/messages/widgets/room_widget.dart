import 'package:a1_chat_app/src/modules/messages/views/chat_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../home/widgets/user_avatar.dart';
import '../models/message.dart';

class RoomWidget extends StatelessWidget {
  const RoomWidget({Key? key, required this.messageRoom}) : super(key: key);
  final MessageRoom messageRoom;

  String getMessageContent(Message message) {
    print(message.content.length);
    if (message.content.length > 70) {
      return "${message.content.substring(0, 70)} ...";
    } else {
      return "${message.content} ...";
    }
  }

  @override
  Widget build(BuildContext context) {

    return InkWell(
      onTap: () {
        context.go('/chat', extra: messageRoom);
      },
      child: SizedBox(
        height: 88,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 15),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              UserAvatar(
                imageUrl: messageRoom.imageUrl,
                isOnline: true,
                radius: 28,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            "${messageRoom.name ?? messageRoom.phoneNumber}",
                            style:
                                Theme.of(context).textTheme.titleMedium?.copyWith(
                                      fontSize: ScreenUtil().setSp(20),
                                    ),
                          ),
                        ),
                        Text(
                          "5 min",
                          style: Theme.of(context).textTheme.caption?.copyWith(
                                color: Theme.of(context).primaryColor,
                              ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 1),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                              getMessageContent(messageRoom.messages!.last!),
                              style: GoogleFonts.rubik(
                                textStyle: Theme.of(context)
                                    .textTheme
                                    .caption
                                    ?.copyWith(fontSize: ScreenUtil().setSp(14)),
                              )),
                        ),
                        const SizedBox(width: 3),
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
                                  ?.copyWith(color: Theme.of(context).cardColor),
                            ),
                          ),
                        ),
                      ],
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
