import 'package:flutter/material.dart';


/// this for single route in the fly ....
// class CustomRoute<T> extends MaterialPageRoute{
//   CustomRoute({
//     WidgetBuilder builder,
//     RouteSettings settings,
// }):super(
//     builder:builder,
//     settings:settings,
//   );
//
//   @override
//   Widget buildTransitions(
//       BuildContext context,
//       Animation<double> animation,
//       Animation<double> secondaryAnimation,
//       Widget child,
//       ){
//     // if(settings.isInitialRoute){
//     //   return child;
//     // }
//     return FadeTransition(
//       opacity : animation,
//       child:child,
//     );
//   }
// }

///this is for hall pages ......
class CustomPageTransitionBuilder extends PageTransitionsBuilder{
  @override
  Widget buildTransitions<T>(
      PageRoute<T> route,
      BuildContext context,
      Animation<double> animation,
      Animation<double> secondaryAnimation,
      Widget child,
      ){
       // if(route.settings.isInitialRoute){
       //     return child;
       //  }
    return FadeTransition(
      opacity : animation,
      child:child,
    );
  }

}