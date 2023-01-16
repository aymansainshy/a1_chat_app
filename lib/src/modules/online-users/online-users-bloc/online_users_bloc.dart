import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'online_users_event.dart';
part 'online_users_state.dart';

class OnlineUsersBloc extends Bloc<OnlineUsersEvent, OnlineUsersState> {
  OnlineUsersBloc() : super(OnlineUsersInitial()) {
    on<OnlineUsersEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
