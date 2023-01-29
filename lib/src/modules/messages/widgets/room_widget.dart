import 'package:a1_chat_app/src/modules/messages/views/chat_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../config/app_config.dart';
import '../../../core/utils/hellper_methods.dart';
import '../../home/widgets/user_avatar.dart';
import '../../online-users/online-users-bloc/online_users_bloc.dart';
import '../models/message.dart';
import 'blue_check_widget.dart';

class RoomWidget extends StatelessWidget {
  const RoomWidget({
    Key? key,
    required this.messageRoom,
    required this.newMessageCount,
  }) : super(key: key);

  final MessageRoom messageRoom;
  final int newMessageCount;

  String getMessageContent(Message message) {
    if (message.content.length > 70) {
      return "${message.content.substring(0, 65)} ...";
    } else {
      return "${message.content} ...";
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        context.go('/chat', extra: ChatData(user: messageRoom.user!, messageToRead: messageRoom.messages.last));
      },
      child: SizedBox(
        height: 80,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              BlocBuilder<OnlineUsersBloc, OnlineUsersState>(
                builder: (context, onlineUserState) {
                  bool isOnline = onlineUserState.users.contains(messageRoom.user);
                  return UserAvatar(
                    imageUrl: "${Application.domain}/uploads/${messageRoom.user?.imageUrl ?? ""}",
                    isOnline: isOnline,
                    radius: ScreenUtil().setSp(27),
                  );
                },
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Text(
                            messageRoom.user?.name ?? messageRoom.user?.phoneNumber ?? "No name",
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontSize: ScreenUtil().setSp(20),
                                ),
                          ),
                        ),
                        Text(
                          getMessageTime(messageRoom.messages.last),
                          style: Theme.of(context).textTheme.caption?.copyWith(
                                color: newMessageCount == 0 ? Colors.grey : Theme.of(context).primaryColor,
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
                              getMessageContent(messageRoom.messages.last),
                              style: GoogleFonts.rubik(
                                textStyle: Theme.of(context).textTheme.caption?.copyWith(fontSize: ScreenUtil().setSp(14)),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 3),
                        if (messageRoom.messages.last.sender == Application.user)
                          SizedBox(
                            width: 21,
                            height: 15,
                            child: ReadBlueCheck(message: messageRoom.messages.last),
                          ),
                        if (newMessageCount != 0)
                          Container(
                            height: 22,
                            width: 22,
                            decoration: BoxDecoration(shape: BoxShape.circle, color: Theme.of(context).primaryColor),
                            child: Center(
                              child: MediaQuery(
                                data: MediaQuery.of(context).copyWith(
                                  textScaleFactor: 1,
                                ),
                                child: Text(
                                  '$newMessageCount',
                                  style: Theme.of(context).textTheme.bodyText2?.copyWith(color: Theme.of(context).cardColor),
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
