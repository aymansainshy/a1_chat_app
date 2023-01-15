import 'package:a1_chat_app/src/modules/messages/widgets/text_message_widget.dart';
import 'package:flutter/material.dart';

import '../../../core/animations/slide_transition.dart';
import '../models/message.dart';

class MessageWidget extends StatelessWidget {
  const MessageWidget({
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
                    backgroundImage: NetworkImage("$avatar"),
                  ),
                ),
              const SizedBox(width: 2),
              TextMessageItem(isMe: isMe, message: message),
            ],
          ),
        ],
      ),
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
