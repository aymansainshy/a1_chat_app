import 'dart:async';

import 'package:a1_chat_app/src/modules/auth/views/login_view.dart';
import 'package:a1_chat_app/src/modules/messages/views/chat_view.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:a1_chat_app/src/modules/home/views/home_view.dart';

import '../modules/auth/auth-bloc/auth_cubit.dart';
import '../modules/auth/views/confirm_otp.dart';
import '../modules/messages/models/message.dart';
import '../modules/online-users/models/user_model.dart';

class RouteName {
  static const home = "home";
  static const login = "login";
  static const otp = "otp";
  static const chat = "chat-view";
}

class AppRouter {
  final AuthCubit authCubit;

  AppRouter(this.authCubit);

  late final router = GoRouter(
    initialLocation: '/', // Splash screen
    routes: <RouteBase>[
      GoRoute(
          path: '/',
          name: RouteName.home,
          pageBuilder: (context, state) => CustomTransitionPage<void>(
                key: state.pageKey,
                restorationId: state.pageKey.value,
                child: const HomeView(),
                transitionsBuilder: (context, animation, secondaryAnimation, child) =>
                    FadeTransition(opacity: animation, child: child),
              ),
          routes: [
            GoRoute(
              path: 'chat',
              name: RouteName.chat,
              builder: (context, state) {
                return ChatView(chatData: state.extra! as ChatData);
              },
            ),
          ]),
      GoRoute(
        path: '/login',
        name: RouteName.login,
        builder: (context, state) => const LoginView(),
        routes: [
          GoRoute(
            path: 'otp',
            name: RouteName.otp,
            builder: (context, state) => PinCodeVerificationView(
              phoneNumber: state.extra! as String,
            ),
          ),
        ],
      ),
    ],
    redirect: ((BuildContext context, GoRouterState state) {
      bool isTryLogin = authCubit.state == const AuthState.isTryLogin();
      bool isAuthenticated = authCubit.state  == const AuthState.authenticated();

      print("isAuthenticated $isAuthenticated");
      print('isTryLogin $isTryLogin');

      final bool isLoginView = state.subloc == '/login';

      if (isAuthenticated) {
        // return '/';
        return null;
      }

      if (!isAuthenticated && isTryLogin) {
        // return '/login/otp';
        return null;
      }

      if (!isAuthenticated) {
        return isLoginView ? null : '/login';
        // return isLoginView ? null : '/';
        // return null;
      }

      return null;
    }),
    refreshListenable: GoRouterRefreshStream(authCubit.stream),
  );
}

class GoRouterRefreshStream extends ChangeNotifier {
  /// Creates a [GoRouterRefreshStream].
  ///
  /// Every time the [stream] receives an event the [GoRouter] will refresh its
  /// current route.
  ///
  GoRouterRefreshStream(Stream<dynamic> stream) {
    notifyListeners();
    _subscription = stream.asBroadcastStream().listen((dynamic _) => notifyListeners());
  }

  late final StreamSubscription<dynamic> _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}





// if the user is not logged in, they need to login
// final loggedIn = loginInfo.loggedIn;
// final loggingIn = state.subloc == '/login';

// // bundle the location the user is coming from into a query parameter
// final fromp = state.subloc == '/' ? '' : '?from=${state.subloc}';
// if (!loggedIn) return loggingIn ? null : '/login$fromp';

// // if the user is logged in, send them where they were going before (or
// // home if they weren't going anywhere)
// if (loggingIn) return state.queryParams['from'] ?? '/';

// // no need to redirect at all
// return null;
