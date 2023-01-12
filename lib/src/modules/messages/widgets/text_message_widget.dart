import 'package:flutter/material.dart';

import '../models/message.dart';

class TextMessageItem extends StatelessWidget {
  const TextMessageItem({
    Key? key,
    required this.isMe,
    required this.message,
    required this.messageRoom,
  }) : super(key: key);

  final bool isMe;
  final Message message;
  final MessageRoom messageRoom;

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context).size;

    // To catculate Time ago ..............
    // var now = new DateTime.now();
    // final difference = now.difference(message.createdAt);
    //
    // var _timeAgo = timeago.format(now.subtract(difference),
    //     locale: AppLanguage.defaultLanguage.languageCode);
    // locale: 'en_short',

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
              Container(
                height: 30,
                width: 30,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                ),
                child: CircleAvatar(
                  backgroundImage: NetworkImage("${messageRoom.imageUrl}"),
                ),
              ),
              const SizedBox(width: 2),
              Container(
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
                  color: isMe ? Colors.yellow[100] : Colors.blue[700],
                  borderRadius: BorderRadius.only(
                    topLeft: const Radius.circular(10),
                    topRight: const Radius.circular(10),
                    bottomLeft: isMe
                        ? const Radius.circular(10)
                        : const Radius.circular(0),
                    bottomRight: isMe
                        ? const Radius.circular(0)
                        : const Radius.circular(10),
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 5),
                    Text(
                      message.content,
                      textAlign: isMe ? TextAlign.right : TextAlign.left,
                      style: Theme.of(context).textTheme.bodyText2?.copyWith(
                            fontSize: 16,
                            color: isMe ? Colors.black : Colors.white,
                          ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      "${DateTime.now()} ",
                      style: Theme.of(context).textTheme.bodyText2?.copyWith(
                            fontSize: 10,
                            color: isMe ? Colors.grey : Colors.grey,
                          ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 2),
              if (!isMe)
                Container(
                  height: 30,
                  width: 30,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                  ),
                  child: CircleAvatar(
                    backgroundImage: NetworkImage(messageRoom.imageUrl!),
                  ),
                ),
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
