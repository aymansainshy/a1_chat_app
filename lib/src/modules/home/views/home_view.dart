import 'package:a1_chat_app/src/core/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../messages/views/rooms_view.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: const [
            UserInformationWidget(),
            ButtonSwitcher(),
            Expanded(
              child: MessagesRoomList(),
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
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: ScreenUtil().setHeight(30),
              decoration: BoxDecoration(
                color: isTapping ? AppColors.blackGray : AppColors.borderColor,
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
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Container(
              height: ScreenUtil().setHeight(30),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: const BorderRadius.all(
                  Radius.circular(20),
                ),
              ),
            ),
          ),
        ],
      ),
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
        // mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          CircleAvatar(
            radius: ScreenUtil().setSp(28),
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                shape: BoxShape.circle,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Transform.translate(
            offset: const Offset(0, 5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Ayman Sainshy",
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
