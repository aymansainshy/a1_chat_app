import 'package:a1_chat_app/src/config/app_config.dart';
import 'package:a1_chat_app/src/core/theme/app_theme.dart';
import 'package:a1_chat_app/src/modules/messages/message-bloc/message_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../messages/views/rooms_view.dart';
import '../../online-users/views/online_user_view.dart';
import '../button_switcher_cubit.dart';
import '../widgets/user_avatar.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            const UserInformationWidget(),
            const ButtonSwitcher(),
            Expanded(
              child: BlocBuilder<ButtonSwitcherCubit, ButtonSwitcherState>(
                builder: (context, state) {
                  if (state.index == 0) {
                    return const MessagesRoomView();
                  } else {
                    return const OnlineUserView();
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ButtonSwitcher extends StatelessWidget {
  const ButtonSwitcher({Key? key}) : super(key: key);
  final bool isTapping = false;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ButtonSwitcherCubit, ButtonSwitcherState>(
      builder: (context, bState) {
        return Padding(
          padding: const EdgeInsets.all(15.0),
          child: Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    BlocProvider.of<ButtonSwitcherCubit>(context).toggleButton(0);
                  },
                  child: BlocBuilder<MessageBloc, MessageBlocState>(
                    builder: (context, messageState) {
                      return Stack(
                        clipBehavior: Clip.none,
                        children: [
                          Container(
                            height: ScreenUtil().setHeight(30),
                            decoration: BoxDecoration(
                              color: bState.index == 0 ? Theme.of(context).primaryColor : AppColors.borderColor,
                              borderRadius: const BorderRadius.all(
                                Radius.circular(20),
                              ),
                            ),
                            child: Center(
                              child: Text(
                                "Messages",
                                style: Theme.of(context).textTheme.bodyText1?.copyWith(
                                      color: Theme.of(context).cardColor,
                                    ),
                              ),
                            ),
                          ),
                          if (messageState.totalNewMessages() != 0)
                            Positioned(
                              top: -5,
                              right: 0,
                              child: Container(
                                height: 23,
                                width: 23,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Theme.of(context).cardColor,
                                ),
                                child: Center(
                                  child: Container(
                                    height: 22,
                                    width: 22,
                                    decoration: BoxDecoration(shape: BoxShape.circle, color: Theme.of(context).primaryColor),
                                    child: Center(
                                      child: MediaQuery(
                                        data: MediaQuery.of(context).copyWith(
                                          textScaleFactor: 1,
                                        ),
                                        child: Text(
                                          '${messageState.totalNewMessages()}',
                                          style:
                                              Theme.of(context).textTheme.bodyText2?.copyWith(color: Theme.of(context).cardColor),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                        ],
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    BlocProvider.of<ButtonSwitcherCubit>(context).toggleButton(1);
                  },
                  child: Container(
                    height: ScreenUtil().setHeight(30),
                    decoration: BoxDecoration(
                      color: bState.index == 1 ? Theme.of(context).primaryColor : AppColors.borderColor,
                      borderRadius: const BorderRadius.all(
                        Radius.circular(20),
                      ),
                    ),
                    child: Center(
                      child: Text(
                        "Online Users",
                        style: Theme.of(context).textTheme.bodyText1?.copyWith(
                              color: Theme.of(context).cardColor,
                            ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class UserInformationWidget extends StatelessWidget {
  const UserInformationWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Transform.translate(
            offset: const Offset(5, 0),
            child: UserAvatar(
              imageUrl: "${Application.domain}/uploads/${Application.user?.imageUrl}" ?? "",
              radius: 30,
            ),
          ),
          const SizedBox(width: 10),
          Transform.translate(
            offset: const Offset(3, 2),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${Application.user?.name ?? Application.user?.phoneNumber} ',
                  style: Theme.of(context).textTheme.headline6,
                ),
                const SizedBox(height: 10),
                Transform.translate(
                  offset: const Offset(0, -5),
                  child: Text(
                    "Online",
                    style: Theme.of(context).textTheme.bodyText2,
                  ),
                ),
              ],
            ),
          ),
          const Spacer(),
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.settings,
            ),
          ),
        ],
      ),
    );
  }
}
