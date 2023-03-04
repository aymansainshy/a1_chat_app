part of 'user_update_bloc.dart';

abstract class UserUpdateState extends Equatable {
  const UserUpdateState();
}

class UserUpdateInitial extends UserUpdateState {
  @override
  List<Object> get props => [];
}

class UserUpdateInProgress extends UserUpdateState {
  @override
  List<Object?> get props => [];
}

class UserUpdateInSuccess extends UserUpdateState {
  @override
  List<Object?> get props => [];
}

class UserUpdateInFailure extends UserUpdateState {
  @override
  List<Object?> get props => [];
}
