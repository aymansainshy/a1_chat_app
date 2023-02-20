import 'dart:io';
import 'dart:ui';

import 'package:a1_chat_app/src/config/app_config.dart';
import 'package:a1_chat_app/src/modules/messages/widgets/text_message_widget.dart';
import 'package:flutter/material.dart';

import '../../../core/utils/hellper_methods.dart';
import '../models/message.dart';

class ImageMessageWidget extends StatelessWidget {
  const ImageMessageWidget({
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
                    color: isMe ? Theme.of(context).backgroundColor : Theme.of(context).primaryColor,
                    borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(18),
                      topRight: const Radius.circular(18),
                      bottomLeft: isMe ? const Radius.circular(18) : const Radius.circular(0),
                      bottomRight: isMe ? const Radius.circular(0) : const Radius.circular(18),
                    ),
                  ),
                  child: ImageContent(message: message!, isMe: isMe)),
            ],
          ),
        ],
      ),
    );
  }
}

class ImageContent extends StatelessWidget {
  const ImageContent({
    required this.message,
    required this.isMe,
    Key? key,
  }) : super(key: key);

  final Message message;
  final bool isMe;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        const SizedBox(height: 5),
        Stack(
          alignment: Alignment.center,
          clipBehavior: Clip.none,
          children: [
            if (!message.content.downloaded!)
              Container(
                height: 200,
                width: double.maxFinite,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(
                      "${Application.domain}/uploads/images/${message.content.fileUrl!}",
                    ),
                    fit: BoxFit.cover,
                  ),
                ),
                child: ClipRRect(
                  // make sure we apply clip it properly
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
                    child: Container(
                      alignment: Alignment.center,
                      color: Colors.grey.withOpacity(0.1),
                    ),
                  ),
                ),
              ),
            if (message.content.downloaded!) Image.file(File(message.content.filePath!)),
            if (message.content.isLoading!)
              Center(
                child: sleekCircularSlider(
                  context,
                  30,
                  Theme.of(context).backgroundColor,
                  Theme.of(context).backgroundColor,
                ),
              ),
            if (!message.content.isLoading! && !message.content.downloaded!)
              Center(
                child: IconButton(
                  onPressed: () {},
                  icon: Icon(
                    Icons.cloud_download_outlined,
                    color: Theme.of(context).backgroundColor,
                    size: 30,
                  ),
                ),
              ),
            if (!message.content.isLoading! && !message.content.uploaded!)
              Center(
                child: IconButton(
                  onPressed: () {},
                  icon: Icon(
                    Icons.cloud_upload_outlined,
                    color: Theme.of(context).backgroundColor,
                    size: 30,
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 3),
        BlueReadCheckAndDate(isMe: isMe, message: message),
      ],
    );
  }
}
