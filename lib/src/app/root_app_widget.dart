import 'package:a1_chat_app/src/app/theme/theme_cubit.dart';
import 'package:a1_chat_app/src/core/utils/assets_utils.dart';
import 'package:a1_chat_app/src/modules/messages/message-bloc/message_bloc.dart';
import 'package:a1_chat_app/src/modules/messages/message-bloc/single_message_bloc/single_message_bloc.dart';
import 'package:a1_chat_app/src/modules/online-users/online-users-bloc/online_users_bloc.dart';
import 'package:a1_chat_app/src/modules/online-users/user-update-bloc/user_update_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'app_config_model.dart';
import '../modules/auth/auth-bloc/otp_bloc.dart';
import '../modules/home/button_switcher_cubit.dart';
import 'app-bloc/app_bloc.dart';
import '../modules/auth/auth-bloc/auth_cubit.dart';
import '../core/constan/const.dart';
import 'theme/app_theme.dart';
import 'views/splash_view.dart';
import '../router/app_router.dart';
import '../../injector.dart';

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    injector<AppBloc>().add(AppStarted());
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AppBloc>(create: (context) => injector<AppBloc>()),
        BlocProvider<OtpBloc>(create: (context) => injector<OtpBloc>()),
        BlocProvider<AuthCubit>(create: (context) => injector<AuthCubit>()),
        BlocProvider<MessageBloc>(create: (context) => injector<MessageBloc>()),
        BlocProvider<ThemeCubit>(create: (context) => injector<ThemeCubit>()),
        BlocProvider<ButtonSwitcherCubit>(create: (context) => injector<ButtonSwitcherCubit>()),
        BlocProvider<OnlineUsersBloc>(create: (context) => injector<OnlineUsersBloc>()),
        BlocProvider<SingleMessageBloc>(create: (context) => injector<SingleMessageBloc>()),
        BlocProvider<UserUpdateBloc>(create: (context) => injector<UserUpdateBloc>()),
      ],
      child: ScreenUtilInit(
        designSize: const Size(360, 640),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (BuildContext context, Widget? child) {
          return BlocConsumer<AppBloc, AppState>(
            listener: (context, appState) {
              if (appState is AppSetupInComplete) {
                if(Application.user != null ){
                  BlocProvider.of<MessageBloc>(context)
                    ..add(GetMessagesRoom())
                    ..add(FetchUserMessages())
                    ..add(FetchUserReceivedMessages());
                }
              }
            },
            builder: (context, appState) {
              if (appState is AppSetupInComplete) {
                return BlocBuilder<ThemeCubit, ThemeState>(
                  builder: (context, themeState) {
                    return MaterialApp.router(
                      debugShowCheckedModeBanner: false,
                      title: kAppName,
                      theme: AppTheme.lightTheme,
                      darkTheme: AppTheme.darkTheme,
                      themeMode: themeState.themeMode,
                      // locale: AppLanguage.defaultLanguage,
                      // localizationsDelegates: const [
                      //   AppLocalization.delegate,
                      //   GlobalWidgetsLocalizations.delegate,
                      //   GlobalMaterialLocalizations.delegate,
                      //   GlobalCupertinoLocalizations.delegate,
                      // ],
                      // supportedLocales: AppLanguage.supportLanguage,
                      routerConfig: injector<AppRouter>().router,
                      // routeInformationParser: AppRouter.router.routeInformationParser,
                      // routerDelegate: AppRouter.router.routerDelegate,
                    );
                  },
                );
              }

              return AnimatedSplashView(
                duration: 800,
                imagePath: AssetsUtils.chatLogo,
              );
            },
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    injector<AuthCubit>().socket.dispose();
    super.dispose();
  }
}
