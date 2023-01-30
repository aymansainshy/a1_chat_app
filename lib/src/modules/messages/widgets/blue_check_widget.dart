import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../core/utils/assets_utils.dart';
import '../models/message.dart';

class ReadBlueCheck extends StatelessWidget {
  const ReadBlueCheck({required this.message, Key? key}) : super(key: key);

  final Message message;

  @override
  Widget build(BuildContext context) {
    if (message.isRead) {
      return SvgPicture.asset(
        AssetsUtils.doublCheckIcon,
        fit: BoxFit.cover,
        height: 18,
        width: 18,
      );
    }
    if (message.isDelivered) {
      return SvgPicture.asset(
        AssetsUtils.doublCheckIcon,
        fit: BoxFit.cover,
        color: Colors.grey,
        height: 18,
        width: 18,
      );
    }
    if (message.isReceive) {
      return SvgPicture.asset(
        AssetsUtils.chekIcon,
        fit: BoxFit.cover,
        color: Colors.grey,
        height: 17,
        width: 17,
      );
    }

    return const Icon(
      Icons.access_time_filled,
      size: 14,
      color: Colors.grey,
    );
  }
}