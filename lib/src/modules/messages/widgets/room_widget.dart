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
        height: 80,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              UserAvatar(
                imageUrl: messageRoom.user?.imageUrl ?? "",
                isOnline: true,
                radius: 26,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                       crossAxisAlignment : CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            messageRoom.user?.name ?? messageRoom.user?.phoneNumber?? "No name",
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(
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
                    Row(
                      children: [
                        Expanded(
                          child: MediaQuery(
                            data: MediaQuery.of(context).copyWith(
                              textScaleFactor: 0.9,
                            ),
                            child: Text(
                                getMessageContent(messageRoom.messages!.last!),
                                style: GoogleFonts.rubik(
                                  textStyle: Theme.of(context)
                                      .textTheme
                                      .caption
                                      ?.copyWith(
                                          fontSize: ScreenUtil().setSp(14)),
                                )),
                          ),
                        ),
                        const SizedBox(width: 3),
                        Container(
                          height: 22,
                          width: 22,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Theme.of(context).primaryColor),
                          child: Center(
                            child: MediaQuery(
                              data: MediaQuery.of(context).copyWith(
                                textScaleFactor: 1,
                              ),
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
