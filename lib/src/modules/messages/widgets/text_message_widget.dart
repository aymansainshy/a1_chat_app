import 'package:flutter/material.dart';

import '../models/message.dart';

class TextMessageItem extends StatelessWidget {
  const TextMessageItem({
    Key? key,
    required this.isMe,
    required this.message,
  }) : super(key: key);

  final Message? message;
  final bool isMe;

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context).size;

    return Container(
      padding: const EdgeInsets.only(
        top: 2,
        bottom: 2,
        left: 8,
        right: 8,
      ),
      constraints: BoxConstraints(
        maxWidth: mediaQuery.width / 1.3,
      ),
      decoration: BoxDecoration(
        color: isMe
            ? Theme.of(context).backgroundColor
            : Theme.of(context).primaryColor,
        borderRadius: BorderRadius.only(
          topLeft: const Radius.circular(15),
          topRight: const Radius.circular(15),
          bottomLeft:
              isMe ? const Radius.circular(15) : const Radius.circular(0),
          bottomRight:
              isMe ? const Radius.circular(0) : const Radius.circular(15),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          const SizedBox(height: 5),
          Text(
            message!.content,
            textAlign: isMe ? TextAlign.right : TextAlign.left,
            style: Theme.of(context).textTheme.bodyText2?.copyWith(
                  fontSize: 16,
                  color: isMe ? Colors.black : Colors.white,
                ),
          ),
          const SizedBox(height: 3),
          Text(
            "${DateTime.now().hour}:${DateTime.now().minute } PM ",
            textAlign: TextAlign.right,
            style: Theme.of(context).textTheme.bodyText2?.copyWith(
                  fontSize: 10,
                  color: isMe ? Colors.grey : Colors.grey,
                ),
          ),
        ],
      ),
    );
  }
}


DateTime newDate = DateTime.now();
DateTime formatedDate = newDate.subtract(
  Duration(
    hours: newDate.hour,
    minutes: newDate.minute,
    seconds: newDate.second,
    milliseconds: newDate.millisecond,
    microseconds: newDate.microsecond,
  ),
);
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
