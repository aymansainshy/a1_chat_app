import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../models/user_model.dart';

part 'online_users_event.dart';

part 'online_users_state.dart';

class OnlineUsersBloc extends Bloc<OnlineUsersEvent, OnlineUsersState> {
  final List<User> onlineUsers = [];

  OnlineUsersBloc() : super(const OnlineUsersState(users: [])) {
    on<NewUser>((event, emit) {
      onlineUsers.add(event.user);
      emit(state.copyWith(users: onlineUsers));
    });
  }
}
