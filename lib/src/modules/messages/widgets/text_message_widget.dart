import 'package:a1_chat_app/src/config/app_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/utils/hellper_methods.dart';
import '../models/message.dart';

class TextMessageWidget extends StatelessWidget {
  const TextMessageWidget({
    Key? key,
    required this.isMe,
    required this.message,
    this.avatar,
  }) : super(key: key);

  final bool isMe;
  final Message? message;
  final String? avatar;

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10, top: 5),
      child: Column(
        mainAxisAlignment:
            isMe ? MainAxisAlignment.start : MainAxisAlignment.end,
        crossAxisAlignment:
            isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment:
                isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
            crossAxisAlignment:
                isMe ? CrossAxisAlignment.start : CrossAxisAlignment.end,
            children: [
              if (!isMe)
                Container(
                  height: 25,
                  width: 25,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                  ),
                  child: CircleAvatar(
                    backgroundImage:
                        NetworkImage("${Application.domain}/uploads/$avatar"),
                  ),
                ),
              const SizedBox(width: 2),
              Container(
                padding: const EdgeInsets.only(
                  top: 4,
                  bottom: 2,
                  left: 10,
                  right: 10,
                ),
                constraints: BoxConstraints(
                  maxWidth: mediaQuery.width / 1.3,
                ),
                decoration: BoxDecoration(
                  color: isMe
                      ? Theme.of(context).backgroundColor
                      : Theme.of(context).primaryColor,
                  borderRadius: BorderRadius.only(
                    topLeft: const Radius.circular(18),
                    topRight: const Radius.circular(18),
                    bottomLeft: isMe
                        ? const Radius.circular(18)
                        : const Radius.circular(0),
                    bottomRight: isMe
                        ? const Radius.circular(0)
                        : const Radius.circular(18),
                  ),
                ),
                child: Column(
                  crossAxisAlignment:
                      isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 5),
                    Text(
                      message?.content ?? '',
                      // textAlign: isMe ? TextAlign.left : TextAlign.right,
                      style: GoogleFonts.rubik(
                        textStyle:
                            Theme.of(context).textTheme.caption?.copyWith(
                                  color: isMe ? Colors.black : Colors.white,
                                  fontSize: ScreenUtil().setSp(15),
                                ),
                      ),
                    ),
                    const SizedBox(height: 3),
                    SizedBox(
                      width: 74,
                      height: 14,
                      child: Row(
                        children: [
                          MediaQuery(
                            data: MediaQuery.of(context).copyWith(
                              textScaleFactor: 1,
                            ),
                            child: Text(
                              getMessageTime(message!),
                              textAlign: TextAlign.right,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText2
                                  ?.copyWith(
                                    fontSize: 10,
                                    color: isMe ? Colors.grey : Colors.grey,
                                  ),
                            ),
                          ),
                          if (isMe) const Spacer(),
                          if (isMe)
                            ReadBlueCheck(
                              message: message!
                            )
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // TextMessageItem(isMe: isMe, message: message),
            ],
          ),
        ],
      ),
    );
  }
}

class ReadBlueCheck extends StatelessWidget {
  const ReadBlueCheck({required this.message, Key? key}) : super(key: key);

  final Message message;

  @override
  Widget build(BuildContext context) {
    if (message.isRead) {
      return Stack(
        clipBehavior: Clip.none,
        children: const [
          Icon(
            Icons.check,
            size: 15,
            color: Colors.blue,
          ),
          Positioned(
            bottom: -1,
            right: 5,
            child: Icon(
              Icons.check,
              size: 15,
              color: Colors.blue,
            ),
          ),
        ],
      );
    }
    if (message.isDelivered) {
      return Stack(
        clipBehavior: Clip.none,
        children: const [
          Icon(
            Icons.check,
            size: 15,
            color: Colors.grey,
          ),
          Positioned(
            bottom: -1,
            right: 5,
            child: Icon(
              Icons.check,
              size: 15,
              color: Colors.grey,
            ),
          ),
        ],
      );
    }
    if (message.isReceive) {
      return const Icon(
        Icons.check,
        size: 15,
        color: Colors.grey,
      );
    }

    return const Icon(
      Icons.access_time_filled,
      size: 14,
      color: Colors.grey,
    );
  }
}


// if (message.messageContent.lat != null &&
// message.messageContent.log != null)
// GestureDetector(
// onTap: () async {
// final locationData = await Location()
//     .getLocation();
//
// AppBlocs.googleMapBloc.add(SelectLocation(
// latLng: LatLng(
// locationData.latitude,
// locationData.longitude,
// ),
// ));
//
// Navigator.of(context).push(MaterialPageRoute(
// builder: (context) =>
// MessageMapDirectionsView(
// originLocations: LatLng(
// message.messageContent.lat,
// message.messageContent.log,
// ),
// selectedLocaions: LatLng(
// locationData.latitude,
// locationData.longitude,
// ),
// ),
// ),
// );
// },
// child: Container(
// // height: 100,
// child: ClipRRect(
// borderRadius: BorderRadius.all(
// Radius.circular(10)),
// child: Image.network(
// "https://maps.googleapis.com/maps/api/staticmap?center=${message
//     .messageContent.lat},${message
//     .messageContent
//     .log}&zoom=14&size=600x300&maptype=roadmap&markers=color:red%7Clabel:A%7C${message
//     .messageContent.lat},${message
//     .messageContent.log}&key=${Application
//     .googleApiKey}",
// fit: BoxFit.cover,
// ),
// ),
// ),
// ),
