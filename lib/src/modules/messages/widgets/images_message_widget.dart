import 'dart:io';
import 'dart:ui';

import 'package:a1_chat_app/src/app/app_config_model.dart';
import 'package:a1_chat_app/src/modules/messages/message-bloc/single_message_bloc/single_message_bloc.dart';
import 'package:a1_chat_app/src/modules/messages/widgets/text_message_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

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
                  padding: const EdgeInsets.only(top: 0, bottom: 7, left: 3, right: 3),
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
    return BlocBuilder<SingleMessageBloc, SingleMessageState>(
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            const SizedBox(height: 3),
            Stack(
              alignment: Alignment.center,
              clipBehavior: Clip.none,
              children: [
                if (!isMe && !message.content.downloaded!)
                  ClipRRect(
                    borderRadius: const BorderRadius.only(topLeft: Radius.circular(15), topRight: Radius.circular(15)),
                    child: Container(
                      constraints: const BoxConstraints(
                        maxHeight: 150,
                      ),
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: NetworkImage(
                            "${Application.domain}/uploads/images/${message.content.fileUrl!}",
                          ),
                          fit: BoxFit.cover,
                        ),
                      ),
                      child: ClipRRect(
                        borderRadius: const BorderRadius.only(topLeft: Radius.circular(15), topRight: Radius.circular(15)),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
                          child: Container(
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              borderRadius: const BorderRadius.only(topLeft: Radius.circular(15), topRight: Radius.circular(15)),
                              color: Colors.grey.withOpacity(0.1),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                if (message.content.downloaded!)
                  GestureDetector(
                    onTap: () {
                      context.push('/chat/file-view', extra: message.content.filePath);
                    },
                    child: Container(
                      constraints: const BoxConstraints(
                        maxHeight: 280,
                        // maxWidth: 200,
                        minWidth: 200,
                      ),
                      child: ClipRRect(
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(15),
                          topRight: Radius.circular(15),
                        ),
                        child: Hero(
                          tag: message.content.filePath!,
                          child: Image.file(
                            File(message.content.filePath!),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  ),
                if (message.content.isLoading!)
                  sleekCircularSlider(
                    context,
                    30,
                    Theme.of(context).colorScheme.background,
                    Theme.of(context).colorScheme.background,
                  ),
                if (!isMe && !message.content.isLoading! && !message.content.downloaded!)
                  IconButton(
                    onPressed: () {
                      BlocProvider.of<SingleMessageBloc>(context).add(DownloadMessageFiles(message));
                    },
                    icon: Icon(
                      Icons.cloud_download_outlined,
                      color: Theme.of(context).colorScheme.background,
                      size: 30,
                    ),
                  ),
                if (isMe && !message.content.isLoading! && !message.content.uploaded!)
                  IconButton(
                    onPressed: () {
                      BlocProvider.of<SingleMessageBloc>(context).add(ReTryUploadMessageFiles(message));
                    },
                    icon: Icon(
                      Icons.cloud_upload_outlined,
                      color: Theme.of(context).colorScheme.background,
                      size: 30,
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 3),
            Padding(
              padding: const EdgeInsets.only(right: 5),
              child: BlueReadCheckAndDate(isMe: isMe, message: message),
            ),
          ],
        );
      },
    );
  }
}
