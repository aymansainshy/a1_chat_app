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
    return Text(
      message!.content,
      textAlign: isMe ? TextAlign.right : TextAlign.left,
      style: Theme.of(context).textTheme.bodyText2?.copyWith(
            fontSize: 16,
            color: isMe ? Colors.black : Colors.white,
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
