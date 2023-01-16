import 'package:flutter/material.dart';

import '../../home/widgets/user_avatar.dart';
import '../widgets/user_widget.dart';

class OnlineUserView extends StatelessWidget {
  const OnlineUserView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 4,
      itemBuilder: (context, i) {
        return const OnlineUserWidget();
      },
    );
  }
}
