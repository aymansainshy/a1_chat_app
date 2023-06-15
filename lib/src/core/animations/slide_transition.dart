import 'package:flutter/material.dart';

enum AnimationDir { rtl, ltr, ttb, btt }

class SlidTransition extends StatefulWidget {
  final Widget? child;
  final AnimationDir animationDir;

  const SlidTransition({
    Key? key,
    this.child,
    this.animationDir = AnimationDir.ltr,
  }) : super(key: key);
  @override
  SlidTransitionState createState() => SlidTransitionState();
}

class SlidTransitionState extends State<SlidTransition>
    with TickerProviderStateMixin {
  late AnimationController _animationController;

  late Animation<Offset> _slidAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    switch (widget.animationDir) {
      case AnimationDir.ltr:
        _slidAnimation = Tween<Offset>(
          begin: const Offset(-5, 0),
          end: const Offset(0, 0),
        ).animate(
          CurvedAnimation(
            parent: _animationController,
            curve: Curves.ease,
          ),
        );
        break;
      case AnimationDir.rtl:
        _slidAnimation = Tween<Offset>(
          begin: const Offset(5, 0),
          end: const Offset(0, 0),
        ).animate(
          CurvedAnimation(
            parent: _animationController,
            curve: Curves.ease,
          ),
        );
        break;
      case AnimationDir.ttb:
        _slidAnimation = Tween<Offset>(
          begin: const Offset(0, -5),
          end: const Offset(0, 0),
        ).animate(
          CurvedAnimation(
            parent: _animationController,
            curve: Curves.ease,
          ),
        );
        break;
      case AnimationDir.btt:
        _slidAnimation = Tween<Offset>(
          begin: const Offset(0, 5),
          end: const Offset(0, 0),
        ).animate(
          CurvedAnimation(
            parent: _animationController,
            curve: Curves.ease,
          ),
        );
        break;
      default:
    }
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _slidAnimation,
      child: widget.child,
    );
  }
}
