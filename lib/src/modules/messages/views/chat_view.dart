import 'dart:io';

import 'package:a1_chat_app/src/modules/messages/message-bloc/message_bloc.dart';
import 'package:a1_chat_app/src/modules/messages/models/message.dart';
import 'package:a1_chat_app/src/modules/online-users/online-users-bloc/online_users_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';

import '../../../app/app_config_model.dart';
import '../../../core/utils/hellper_methods.dart';
import '../../../core/utils/preference_utils.dart';
import '../../home/widgets/user_avatar.dart';
import '../../online-users/models/user_model.dart';
import '../widgets/images_message_widget.dart';
import '../widgets/text_message_widget.dart';

class ChatData {
  final User user;
  final Message? messageToRead;

  ChatData({required this.user, this.messageToRead});
}

class ChatView extends StatefulWidget {
  const ChatView({
    Key? key,
    required this.chatData,
  }) : super(key: key);

  final ChatData chatData;

  @override
  State<ChatView> createState() => _ChatViewState();
}

class _ChatViewState extends State<ChatView> {
  final TextEditingController _textEditingController = TextEditingController();
  final ScrollController _chatScrollController = ScrollController();
  final FocusNode _inputFocus = FocusNode();

  final _formKey = GlobalKey<FormState>();

  String messageText = '';
  File? messageImage;

  @override
  void initState() {
    super.initState();

    if (widget.chatData.messageToRead != null) {
      BlocProvider.of<MessageBloc>(context).add(IReadMessage(message: widget.chatData.messageToRead!));
    }

    BlocProvider.of<MessageBloc>(context).add(OpenMessagesRoom(widget.chatData.user.phoneNumber!));
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    _inputFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = widget.chatData.user;

    return WillPopScope(
      onWillPop: () async {
        BlocProvider.of<MessageBloc>(context).add(const OpenMessagesRoom(''));
        return Future(() => true);
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).primaryColor,
          titleTextStyle: Theme.of(context).appBarTheme.titleTextStyle?.copyWith(color: Colors.white),
          titleSpacing: MediaQuery.of(context).size.width/ 250,
          title: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              // IconButton(
              //   onPressed: () {
              //     BlocProvider.of<MessageBloc>(context).add(const OpenMessagesRoom(''));
              //     context.go('/');
              //   },
              //   icon: const Icon(Icons.arrow_back),
              // ),
              BlocBuilder<OnlineUsersBloc, OnlineUsersState>(
                builder: (context, onlineUserState) {
                  bool isOnline = onlineUserState.users.contains(user);
                  return UserAvatar(
                    imageUrl: "${Application.domain}/uploads/${user.imageUrl}",
                    radius: 22,
                    isOnline: isOnline,
                  );
                },
              ),
              const SizedBox(width: 8),
              Transform.translate(
                offset: const Offset(0, 1),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "${user.name ?? user.phoneNumber}",
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Colors.white,
                        fontSize: 19,
                      ),
                    ),
                    const SizedBox(height: 8),
                    LastSeenInformationWidget(user: user),
                  ],
                ),
              ),
              const Spacer(),
              Transform.translate(
                offset: const Offset(-15, 0),
                child: const Icon(Icons.info_outline),
              )
            ],
          ),
        ),
        backgroundColor: Theme.of(context).colorScheme.background,
        body: BlocConsumer<MessageBloc, MessageBlocState>(
          listener: (context, messageState) {
            // if (messageState is SendMessageWithNotificationSuccess) {
            //   ScaffoldMessenger.maybeOf(context).showSnackBar(
            //       SnackBar(content: Text("تم ارسال اخر رسالة بنجاح")));
            // }
          },
          builder: (context, messageState) {
            final List<Message>? messages =
                messageState.messageRooms[widget.chatData.user.phoneNumber]?.messages.reversed.toList();

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      // borderRadius: const BorderRadius.only(
                      //   topLeft: Radius.circular(45),
                      //   topRight: Radius.circular(45),
                      // ),
                    ),
                    child: isMessagesNullOrEmpty(messages)
                        ? const Center(
                            child: Text('Start messaging '),
                          )
                        : GroupedListView<Message, DateTime>(
                            reverse: true,
                            controller: _chatScrollController,
                            elements: messages!,
                            groupBy: (Message message) => DateTime(
                              -message.createdAt.year,
                              -message.createdAt.month,
                              -message.createdAt.day,
                            ),
                            groupHeaderBuilder: (message) => SizedBox(
                              height: 35,
                              child: Align(
                                child: Container(
                                  width: 100,
                                  decoration: const BoxDecoration(
                                    color: Colors.black54, //Theme.of(context).backgroundColor,
                                    borderRadius: BorderRadius.all(Radius.circular(25.0)),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Text(
                                      DateFormat.yMMMd().format(message.createdAt),
                                      textAlign: TextAlign.center,
                                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                            fontSize: 12,
                                            color: Colors.white,
                                          ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            indexedItemBuilder: (context, dynamic _, i) {
                              var isMe = isMeCheck(messages[i]);

                              if (messages[i].messageType == MessageType.text) {
                                return TextMessageWidget(
                                  isMe: isMe,
                                  message: messages[i],
                                  avatar: user.imageUrl,
                                );
                              } else {
                                return ImageMessageWidget(
                                  isMe: isMe,
                                  message: messages[i],
                                  avatar: user.imageUrl,
                                );
                              }
                            },
                            useStickyGroupSeparators: true,
                            floatingHeader: true,
                            order: GroupedListOrder.ASC,
                          ),
                  ),
                ),
                // const SizedBox(height: 5),
                Container(
                  padding: const EdgeInsets.only(top: 15, bottom: 10, left: 15, right: 15),
                  color: Theme.of(context).cardColor,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.grey.shade300,
                            borderRadius: const BorderRadius.all(
                              Radius.circular(25),
                            ),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Form(
                                  key: _formKey,
                                  child: TextFormField(
                                    maxLines: 4,
                                    minLines: 1,
                                    focusNode: _inputFocus,
                                    // autofocus: false,
                                    // textDirection: TextDirection.LTR,
                                    decoration: InputDecoration(
                                      labelText: "  Message ...",
                                      // labelStyle: TextStyle(
                                      //   fontSize: screenUtil.setSp(30),
                                      // ),
                                      contentPadding: const EdgeInsets.all(10.0),
                                      errorBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(30),
                                        borderSide: BorderSide.none,
                                      ),
                                      focusedErrorBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(30),
                                        borderSide: BorderSide.none,
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(30),
                                        borderSide: BorderSide.none,
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(30),
                                        borderSide: BorderSide.none,
                                      ),
                                      filled: true,
                                      fillColor: Colors.grey.shade300,
                                      focusColor: Theme.of(context).primaryColor,
                                      floatingLabelBehavior: FloatingLabelBehavior.never,
                                    ),
                                    controller: _textEditingController,
                                    validator: (value) {
                                      if (value!.trim().isEmpty) {
                                        return;
                                      }
                                      return null;
                                    },
                                    onSaved: (value) {
                                      messageText = _textEditingController.value.text;
                                    },
                                  ),
                                ),
                              ),
                              IconButton(
                                onPressed: () async {
                                  final messageBloc = BlocProvider.of<MessageBloc>(context);

                                  final ImagePicker picker = ImagePicker();
                                  final XFile? image = await picker.pickImage(source: ImageSource.gallery);

                                  final savePath = "${Application.storageDir?.path}/downloads/${image?.name}";

                                  await image?.saveTo(savePath);

                                  if (image != null) {
                                    late MContent messageContent = MContent(filePath: savePath);
                                    var imageMessage = Message(
                                      id: DateTime.now().toIso8601String(),
                                      uuid: DateTime.now().toIso8601String(),
                                      messageType: MessageType.media,
                                      sender: Application.user,
                                      receiver: user,
                                      content: messageContent,
                                      createdAt: DateTime.now(),
                                      receivedAt: DateTime.now(),
                                    );

                                    messageBloc.add(SendFileMessage(message: imageMessage));
                                  }
                                },
                                icon: Icon(
                                  Icons.camera_alt,
                                  color: Theme.of(context).primaryColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 3),
                      InkWell(
                        onTap: () {
                          // var isValid = _formKey.currentState?.validate();

                          _formKey.currentState?.save();

                          if (messageText.isEmpty) {
                            return;
                          }

                          late MContent messageContent = MContent(text: messageText);
                          var newMessage = Message(
                            id: DateTime.now().toIso8601String(),
                            uuid: DateTime.now().toIso8601String(),
                            messageType: MessageType.text,
                            sender: Application.user,
                            receiver: user,
                            content: messageContent,
                            createdAt: DateTime.now(),
                            receivedAt: DateTime.now(),
                          );

                          _textEditingController.clear();

                          // Scroll to the bottom of chat View .....
                          if (_chatScrollController.hasClients) {
                            final position = _chatScrollController.position.minScrollExtent;
                            _chatScrollController.jumpTo(position);
                          }

                          BlocProvider.of<MessageBloc>(context).add(SendTextMessage(message: newMessage));
                        },
                        child: Container(
                          height: 45,
                          width: 45,
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(color: Theme.of(context).primaryColor, shape: BoxShape.circle),
                          child: Icon(
                            Icons.arrow_forward,
                            color: Theme.of(context).cardColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class LastSeenInformationWidget extends StatelessWidget {
  const LastSeenInformationWidget({
    required this.user,
    Key? key,
  }) : super(key: key);

  final User user;

  @override
  Widget build(BuildContext context) {
    return Transform.translate(
      offset: const Offset(0, -5),
      child: BlocBuilder<OnlineUsersBloc, OnlineUsersState>(
        builder: (context, onlineUserState) {
          bool isOnline = onlineUserState.users.contains(user);
          if (isOnline) {
            return Text(
              "Online",
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.white,
                  ),
            );
          } else {
            final lastSeen = PreferencesUtils.getString(user.phoneNumber!);

            if (lastSeen != null) {
              final lastSeenData = lastSeenTime(lastSeen);
              return Text(
                "Last Seen : $lastSeenData",
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.white,
                    ),
              );
            }

            return Text(
              "Last Seen : Recently",
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.white,
                  ),
            );
          }
        },
      ),
    );
  }
}

bool isMessagesNullOrEmpty(List<Message?>? messages) {
  return messages == null || messages.isEmpty;
}

String lastSeenTime(String lastSeenDate) {
  final now = DateTime.now();

  final lastSeen = DateTime.parse(lastSeenDate);

  final today = DateTime(now.year, now.month, now.day);
  final yesterday = DateTime(now.year, now.month, now.day - 1);

  final fLastSeen = DateTime(lastSeen.year, lastSeen.month, lastSeen.day);

  if (fLastSeen == today) {
    final formatDate = DateFormat('hh:mm a').format(lastSeen);
    return formatDate;
  } else if (fLastSeen == yesterday) {
    return "Yesterday";
  } else {
    return "${lastSeen.day}/${lastSeen.month}/${lastSeen.year}";
  }
}
