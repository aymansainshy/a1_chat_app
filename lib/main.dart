import 'package:a1_chat_app/src/modules/auth/auth-bloc/auth_cubit.dart';
import 'package:a1_chat_app/src/modules/home/app-bloc/app_bloc.dart';
import 'package:a1_chat_app/src/modules/home/views/splash_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:a1_chat_app/app_blocs.dart';
import 'package:a1_chat_app/src/core/constan/const.dart';
import 'package:a1_chat_app/src/core/theme/app_theme.dart';

import 'package:a1_chat_app/src/router/app_router.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();

    AppBlocs.appBloc.add(AppStarted());
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: AppBlocs.providers,
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
                  routerConfig: AppRouter(context.read<AuthCubit>()).router,
                  // routeInformationParser: AppRouter.router.routeInformationParser,
                  // routerDelegate: AppRouter.router.routerDelegate,
                );
              }
              return AnimatedSplashView(duration: 1000, imagePath: "ddfdfdf");
            },
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    AppBlocs.dispose();
    super.dispose();
  }
}
