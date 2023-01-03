import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../config/app_config.dart';

enum AuthStatus { unknown, authenticated, unAuthenticated, isTryLogin }

class AuthState extends Equatable {
  final AuthStatus status;

  const AuthState._({this.status = AuthStatus.unknown});

  const AuthState.authenticated() : this._(status: AuthStatus.authenticated);

  const AuthState.unAuthenticated() : this._(status: AuthStatus.unAuthenticated);

  const AuthState.isTryLogin() : this._(status: AuthStatus.isTryLogin);

  @override
  List<Object?> get props => [status];
}

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(const AuthState._());

  void checkAuth() {
    if (Application.user != null) {
      emit(const AuthState.authenticated());
    } else {
      emit(const AuthState.unAuthenticated());
    }
  }

  void tryLogin() {
    emit(const AuthState.isTryLogin());
  }
}
