import 'package:a1_chat_app/src/app/app-bloc/app_bloc.dart';
import 'package:a1_chat_app/src/app/theme/app_theme.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../core/constan/const.dart';
import '../../core/errors/custom_error_dialog.dart';

late int _duration;
late String _imagePath;

class AnimatedSplashView extends StatefulWidget {
  AnimatedSplashView({
    Key? key,
    required int duration,
    required String imagePath,
  }) : super(key: key) {
    _duration = duration;
    _imagePath = imagePath;
  }

  @override
  AnimatedSplashState createState() => AnimatedSplashState();
}

class AnimatedSplashState extends State<AnimatedSplashView> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    if (_duration < 800) _duration = 800;

    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: _duration),
    );

    _animation = Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(parent: _animationController, curve: Curves.easeInCirc));

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var isLandScape = MediaQuery.of(context).orientation == Orientation.landscape;
    var mediaQuery = MediaQuery.of(context).size;

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: const Color.fromARGB(255, 232, 235, 243),
        body: FadeTransition(
          opacity: _animation,
          child: BlocListener<AppBloc, AppState>(
            listener: (context, appState) {
              if (appState is AppSetupInFailure) {
                if(kDebugMode) {
                  print(appState.error.toString());
                }
                simpleErrorDialog(context, () {
                  BlocProvider.of<AppBloc>(context).add(AppStarted());
                });
              }
            },
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  const SizedBox(height: 40),
                  Transform.translate(
                    offset: const Offset(0, 30),
                    child: Container(
                      padding: const EdgeInsets.all(30),
                      height: isLandScape ? ScreenUtil().setHeight(700) : mediaQuery.height / 3,
                      width: isLandScape ? ScreenUtil().setWidth(700) : mediaQuery.width,
                      child: Hero(
                        tag: klogoAnimation,
                        child: SvgPicture.asset(
                          _imagePath,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: isLandScape ? ScreenUtil().setHeight(800) : ScreenUtil().setHeight(200),
                    width: isLandScape ? ScreenUtil().setWidth(700) : ScreenUtil().setWidth(800),
                    child: const SpinKitThreeBounce(
                      color: AppColors.borderColor,
                      size: 19,
                      duration: Duration(milliseconds: 800),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
