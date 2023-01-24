import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';

import '../../config/app_config.dart';
import '../../modules/messages/models/message.dart';

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

bool isMeCheck(Message? message) {
  return message?.sender == Application.user;
}

String getMessageTime(Message message) {
  final now = DateTime.now();
  final messageDate = message.createdAt;

  final today = DateTime(now.year, now.month, now.day);
  final yesterday = DateTime(now.year, now.month, now.day - 1);

  final aDate = DateTime(messageDate.year, messageDate.month, messageDate.day);

  if (aDate == today) {
   final formatDate =  DateFormat('hh:mm a').format(messageDate);
    return formatDate;
  } else if (aDate == yesterday) {
    return "Yesterday";
  } else {
    return "${messageDate.day}/${messageDate.month}/${messageDate.year}";
  }
}

extension DateUtils on DateTime {
  bool get isToday {
    final now = DateTime.now();
    return now.day == day && now.month == month && now.year == year;
  }

  bool get isTomorrow {
    final tomorrow = DateTime.now().add(const Duration(days: 1));
    return tomorrow.day == day &&
        tomorrow.month == month &&
        tomorrow.year == year;
  }

  bool get isYesterday {
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    return yesterday.day == day &&
        yesterday.month == month &&
        yesterday.year == year;
  }
}
