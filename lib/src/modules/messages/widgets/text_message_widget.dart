import 'package:a1_chat_app/src/app/app_config_model.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../models/message.dart';
import 'blue_check_widget.dart';

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
        // mainAxisAlignment: isMe ? MainAxisAlignment.start : MainAxisAlignment.end,
        // crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
            crossAxisAlignment: isMe ? CrossAxisAlignment.start : CrossAxisAlignment.end,
            children: [
              if (!isMe)
                Container(
                  height: 20,
                  width: 20,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                  ),
                  child: CircleAvatar(
                    backgroundImage: NetworkImage("${Application.domain}/uploads/$avatar"),
                  ),
                ),
              const SizedBox(width: 2),
              Container(
                padding: const EdgeInsets.only(top: 7, bottom: 7, left: 10, right: 10),
                constraints: BoxConstraints(
                  maxWidth: mediaQuery.width / 1.2,
                ),
                decoration: BoxDecoration(
                  color: isMe ? Theme.of(context).colorScheme.background : Theme.of(context).primaryColor,
                  borderRadius: BorderRadius.only(
                    topLeft: const Radius.circular(18),
                    topRight: const Radius.circular(18),
                    bottomLeft: isMe ? const Radius.circular(18) : const Radius.circular(0),
                    bottomRight: isMe ? const Radius.circular(0) : const Radius.circular(18),
                  ),
                ),
                child: Content(message: message!, isMe: isMe),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class Content extends StatelessWidget {
  const Content({
    required this.message,
    required this.isMe,
    Key? key,
  }) : super(key: key);

  final Message message;
  final bool isMe;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.end,
      children: [
        MessageContent(message: message, isMe: isMe),
        const SizedBox(width: 5),
        Transform.translate(
          offset: const Offset(0, 3),
          child: BlueReadCheckAndDate(isMe: isMe, message: message),
        ),
      ],
    );
  }
}

class MessageContent extends StatelessWidget {
  const MessageContent({
    required this.message,
    required this.isMe,
    Key? key,
  }) : super(key: key);

  final Message message;
  final bool isMe;

  @override
  Widget build(BuildContext context) {
    return SelectableText(
      message.content.text ?? '',
      style: GoogleFonts.rubik(
        textStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: isMe ? Colors.black : Colors.white,
            ),
      ),
    );
  }
}

class BlueReadCheckAndDate extends StatelessWidget {
  const BlueReadCheckAndDate({
    required this.message,
    required this.isMe,
    Key? key,
  }) : super(key: key);

  final Message message;
  final bool isMe;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: isMe ? 70 : 50,
      height: 14,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          MediaQuery(
            data: MediaQuery.of(context).copyWith(
              textScaleFactor: 1,
            ),
            child: Text(
              DateFormat('hh:mm a').format(message.createdAt),
              textAlign: TextAlign.right,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontSize: 10,
                    color: isMe ? Colors.grey : Colors.grey,
                  ),
            ),
          ),
          if (isMe) const Spacer(),
          if (isMe) ReadBlueCheck(message: message)
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
