import 'package:a1_chat_app/src/core/utils/assets_utils.dart';
import 'package:a1_chat_app/src/modules/messages/message-bloc/message_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../modules/auth/auth-bloc/otp_bloc.dart';
import 'app-bloc/app_bloc.dart';
import '../modules/auth/auth-bloc/auth_cubit.dart';
import '../core/constan/const.dart';
import '../core/theme/app_theme.dart';
import 'views/splash_view.dart';
import '../router/app_router.dart';
import '../../injector.dart';

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    injector<AppBloc>().add(AppStarted());
    injector<MessageBloc>().add(GetMessages());
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AppBloc>(create: (context) => injector<AppBloc>()),
        BlocProvider<OtpBloc>(create: (context) => injector<OtpBloc>()),
        BlocProvider<AuthCubit>(create: (context) => injector<AuthCubit>()),
        BlocProvider<MessageBloc>(create: (context) => injector<MessageBloc>()),
      ],
      child: ScreenUtilInit(
        designSize: const Size(360, 640),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (BuildContext context, Widget? child) {
          return BlocConsumer<AppBloc, AppState>(
            listener: (context, appState) {
              // TODO: implement listener
            },
            builder: (context, appState) {
              if (appState is AppSetupInComplete) {
                return MaterialApp.router(
                  debugShowCheckedModeBanner: false,
                  title: kAppName,
                  theme: AppTheme.lightTheme,
                  darkTheme: AppTheme.darkTheme,
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
              }
              return AnimatedSplashView(
                  duration: 1000, imagePath: AssetsUtils.chatLogo);
            },
          );
        },
      ),
    );
  }
}
