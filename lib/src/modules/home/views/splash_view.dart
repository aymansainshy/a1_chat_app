import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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

class AnimatedSplashState extends State<AnimatedSplashView>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    if (_duration < 1000) _duration = 2000;

    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: _duration),
    );

    _animation = Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(
        parent: _animationController, curve: Curves.easeInCirc));

    _animationController.forward();
  }

  @override
  void dispose() {
    super.dispose();
    _animationController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var isLandScape =
        MediaQuery.of(context).orientation == Orientation.landscape;

    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.blue,
        body: FadeTransition(
          opacity: _animation,
          child: Center(
            child: SizedBox(
              height: isLandScape
                  ? ScreenUtil().setHeight(2000)
                  : ScreenUtil().setHeight(200),
              width: isLandScape
                  ? ScreenUtil().setWidth(700)
                  : ScreenUtil().setWidth(200),
              child: Container(
                color: Colors.white,
              ),
              //  Image.asset(
              //   _imagePath,
              //   fit: isLandScape ? BoxFit.fill : BoxFit.contain,
              // ),
            ),
          ),
        ),
      ),
    );
  }
}
