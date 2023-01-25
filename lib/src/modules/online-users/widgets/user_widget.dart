import 'package:a1_chat_app/src/modules/online-users/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../config/app_config.dart';
import '../../home/widgets/user_avatar.dart';

class OnlineUserWidget extends StatelessWidget {
  const OnlineUserWidget({required this.user, Key? key}) : super(key: key);

  final User user;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        context.go('/chat', extra: user);
      },
      child: SizedBox(
        height: 80,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
          child: Row(
            children: [
              UserAvatar(
                imageUrl: "${Application.domain}/uploads/${user.imageUrl}",
                isOnline: true,
                radius: ScreenUtil().setSp(25),
              ),
              const SizedBox(width: 8),
              Transform.translate(
                offset: const Offset(0, 0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      user.name ?? user.phoneNumber!,
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium
                          ?.copyWith(fontSize: 20),
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
