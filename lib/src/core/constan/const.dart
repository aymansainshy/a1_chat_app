import 'package:flutter/material.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';

const String kAppName = "A1 Chat";
const String klogoAnimation = "logoAnimation";




// String translate(String text, BuildContext context) {
//   return AppLocalizations.of(context).translate(text)!;
// }

Widget sleekCircularSlider(
    BuildContext context, double size, Color color1, Color color2) {
  return SleekCircularSlider(
    initialValue: 20,
    max: 100,
    onChange: (v) {},
    appearance: CircularSliderAppearance(
      spinnerMode: true,
      infoProperties: InfoProperties(),
      angleRange: 360,
      startAngle: 90,
      size: size,
      customColors: CustomSliderColors(
        hideShadow: true,
        dotColor: Colors.transparent,
        progressBarColors: [color1, color2],
        trackColor: Colors.transparent,
      ),
      customWidths: CustomSliderWidths(
        progressBarWidth: 4.0,
        trackWidth: 3.0,
      ),
    ),
  );
}