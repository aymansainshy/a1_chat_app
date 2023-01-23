import 'package:a1_chat_app/src/modules/online-users/online-users-bloc/online_users_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../home/widgets/user_avatar.dart';
import '../widgets/user_widget.dart';

class OnlineUserView extends StatelessWidget {
  const OnlineUserView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OnlineUsersBloc, OnlineUsersState>(
      builder: (context, state) {
        if (state.users.isEmpty) {
          return const Center(
            child: Text("No online user at the moment !"),
          );
        } else {
          return ListView.builder(
            itemCount: state.users.length,
            itemBuilder: (context, i) {
              return OnlineUserWidget(user: state.users[i]);
            },
          );
        }
      },
    );
  }
}
