import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'user_update_event.dart';
part 'user_update_state.dart';

class UserUpdateBloc extends Bloc<UserUpdateEvent, UserUpdateState> {
  UserUpdateBloc() : super(UserUpdateInitial()) {
    on<UserUpdateEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
