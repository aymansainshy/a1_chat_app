
import 'package:a1_chat_app/src/modules/online-users/repository/user_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../config/app_config.dart';
import '../models/user_model.dart';

part 'online_users_event.dart';

part 'online_users_state.dart';

class OnlineUsersBloc extends Bloc<OnlineUsersEvent, OnlineUsersState> {
  final OnlineUserRepository onlineUserRepository;
  final List<User>? onlineUsers = [];

  OnlineUsersBloc(this.onlineUserRepository) : super(const OnlineUsersState(users: [])) {
    on<GetOnlineUser>((event, emit) async {

      final onlineUsers = await onlineUserRepository.getOnlineUsers();
      if (onlineUsers == null) {
        return;
      }
      if (onlineUsers.contains(Application.user)) {
        onlineUsers.remove(Application.user);
      }
      emit(state.copyWith(users: onlineUsers));
    });


    on<NewUser>((event, emit) {
      if (onlineUsers!.contains(event.user)) {
        return;
      }
      onlineUsers?.add(event.user);
      emit(state.copyWith(users: onlineUsers));
    });


    on<UserDisconnected>((event, emit) {
      if (!onlineUsers!.contains(event.user)) {
        return;
      }

      onlineUsers?.remove(event.user);
      emit(state.copyWith(users: onlineUsers));
    });
  }
}
