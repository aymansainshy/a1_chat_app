part of 'user_update_bloc.dart';

abstract class UserUpdateEvent extends Equatable {
  const UserUpdateEvent();
}

class UpdateUserName extends UserUpdateEvent {
  @override
  List<Object?> get props => [];
}
