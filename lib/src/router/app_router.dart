import 'dart:async';

import 'package:a1_chat_app/src/core/utils/assets_utils.dart';
import 'package:a1_chat_app/src/modules/auth/views/login_view.dart';
import 'package:a1_chat_app/src/app/views/splash_view.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:a1_chat_app/src/modules/home/views/home_view.dart';

import '../modules/auth/auth-bloc/auth_cubit.dart';
import '../modules/auth/views/confirm_otp.dart';

class RouteName {
  static const splash = "splash";
  static const home = "home";
  static const login = "login";
  static const otp = "otp";
}

class AppRouter {
  final AuthCubit authCubit;

  AppRouter(this.authCubit);

  late final router = GoRouter(
    initialLocation: '/', // Splash screen
    routes: [
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
      ),
      GoRoute(
        path: '/login',
        name: RouteName.login,
        builder: (context, state) => const LoginView(),
      ),
      GoRoute(
        path: '/otp',
        name: RouteName.otp,
        builder: (context, state) => const PinCodeVerificationView(
          phoneNumber: "0924081893",
          name: "Ayman",
        ),
      ),
      // GoRoute(
      //   path: '/splash',
      //   name: RouteName.splash,
      //   builder: (context, state) =>  AnimatedSplashView(duration: 3000, imagePath: AssetsUtils.chatLogo,),
      // ),
    ],
    redirect: ((BuildContext context, GoRouterState state) {
      bool isAuthenticated = authCubit.state.status == AuthStatus.authenticated;

      final bool isLoginView = state.subloc == '/login';

      if (!isAuthenticated) {
        return isLoginView ? null : '/login';
      }

      // ignore: dead_code
      if (isAuthenticated) {
        return '/';
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
    _subscription = stream.asBroadcastStream().listen(
          (dynamic _) => notifyListeners(),
        );
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
