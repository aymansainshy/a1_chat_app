part of 'online_users_bloc.dart';

abstract class OnlineUsersEvent extends Equatable {
  const OnlineUsersEvent();
}

class NewUser extends OnlineUsersEvent {
  final User user;

  const NewUser(this.user);

  @override
  List<Object?> get props => [user.id];
}

class GetOnlineUser extends OnlineUsersEvent {
  @override
  List<Object?> get props => [];
}

class UserDisconnected extends OnlineUsersEvent {
  final User user;

  const UserDisconnected(this.user);

  @override
  List<Object?> get props => [user.id];
}
