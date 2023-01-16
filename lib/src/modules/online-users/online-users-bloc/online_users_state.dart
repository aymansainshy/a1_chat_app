part of 'online_users_bloc.dart';

abstract class OnlineUsersState extends Equatable {
  const OnlineUsersState();
}

class OnlineUsersInitial extends OnlineUsersState {
  @override
  List<Object> get props => [];
}
