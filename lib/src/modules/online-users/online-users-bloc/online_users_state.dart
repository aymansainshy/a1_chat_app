part of 'online_users_bloc.dart';

class OnlineUsersState {
  final List<User> users;

  const OnlineUsersState({required this.users});

  OnlineUsersState copyWith({List<User>? users}) {
    return OnlineUsersState(users: users ?? this.users);
  }
}
