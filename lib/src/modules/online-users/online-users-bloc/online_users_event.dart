part of 'online_users_bloc.dart';

abstract class OnlineUsersEvent extends Equatable {
  const OnlineUsersEvent();
}


class NewUser extends OnlineUsersEvent {
  final User user;

  const NewUser(this.user);

  @override
  List<Object?> get props => [user];

}