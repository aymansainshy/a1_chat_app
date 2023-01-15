import 'package:a1_chat_app/src/core/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../messages/views/rooms_view.dart';
import '../widgets/user_avatar.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

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
          children: const [
            UserInformationWidget(),
            ButtonSwitcher(),
            Expanded(
              child: MessagesRoomView(),
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
                color: Theme.of(context).primaryColor,
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
                color: isTapping ? AppColors.blackGray : AppColors.borderColor,
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
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Transform.translate(
            offset: const Offset(5, 0),
            child: const UserAvatar(
              imageUrl:
                  'https://spcfonline.com/wp-content/uploads/2021/11/profile-pic.jpg',
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
