import 'package:a1_chat_app/src/modules/messages/message-bloc/message_bloc.dart';
import 'package:a1_chat_app/src/modules/messages/models/message.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../config/app_config.dart';
import '../../../core/utils/hellper_methods.dart';
import '../../home/widgets/user_avatar.dart';
import '../../online-users/models/user_model.dart';
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

  final _formKey = GlobalKey<FormState>();

  String messageText = '';

  @override
  void initState() {
    super.initState();
    BlocProvider.of<MessageBloc>(context).add(IReadMessage(message: widget.chatData.messageToRead!));

    BlocProvider.of<MessageBloc>(context).add(OpenMessagesRoom(widget.chatData.user.phoneNumber!));
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        BlocProvider.of<MessageBloc>(context).add(const OpenMessagesRoom(''));
        return Future(() => false);
      },
      child: Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        body: BlocConsumer<MessageBloc, MessageBlocState>(
          listener: (context, messageState) {
            // if (messageState is SendMessageWithNotificationSuccess) {
            //   ScaffoldMessenger.maybeOf(context).showSnackBar(
            //       SnackBar(content: Text("تم ارسال اخر رسالة بنجاح")));
            // }
          },
          builder: (context, messageState) {
            final List<Message?>? messages =
                messageState.messageRooms[widget.chatData.user.phoneNumber]?.messages?.reversed.toList();
            final user = widget.chatData.user;
            return SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 80,
                    child: Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          IconButton(
                            onPressed: () {
                              BlocProvider.of<MessageBloc>(context).add(const OpenMessagesRoom(''));
                              context.go('/');
                            },
                            icon: const Icon(Icons.arrow_back),
                          ),
                          UserAvatar(
                            imageUrl: "${Application.domain}/uploads/${user.imageUrl}",
                            radius: 26,
                            isOnline: true,
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
                                  style: Theme.of(context).textTheme.titleMedium?.copyWith(fontSize: 20),
                                ),
                                const SizedBox(height: 8),
                                Transform.translate(
                                  offset: const Offset(0, -5),
                                  child: Text(
                                    "Online",
                                    style: Theme.of(context).textTheme.bodyText2,
                                  ),
                                ),
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
                  ),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(45),
                          topRight: Radius.circular(45),
                        ),
                      ),
                      child: isMessagesNullOrEmpty(messages)
                          ? const Center(
                              child: Text('Start messaging '),
                            )
                          : ListView.builder(
                              reverse: true,
                              itemCount: messages?.length,
                              itemBuilder: (context, i) {
                                var isMe = isMeCheck(messages?[i]);
                                return TextMessageWidget(
                                  isMe: isMe,
                                  message: messages?[i],
                                  avatar: user.imageUrl,
                                );
                              },
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
                          child: Form(
                            key: _formKey,
                            child: TextFormField(
                              maxLines: 4,
                              minLines: 1,
                              // autofocus: true,
                              textDirection: TextDirection.ltr,
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
                              // validator: (value) {
                              //   if (value?.trim().isEmpty) {
                              //     return ;
                              //   }
                              //   return null;
                              // },
                              onSaved: (value) {
                                messageText = _textEditingController.value.text;
                              },
                            ),
                          ),
                        ),
                        const SizedBox(width: 3),
                        InkWell(
                          onTap: () async {
                            _formKey.currentState?.save();

                            var newMessage = Message(
                              id: DateTime.now().toIso8601String(),
                              sender: Application.user,
                              receiver: user,
                              content: messageText,
                              createdAt: DateTime.now(),
                            );

                            _textEditingController.clear();

                            BlocProvider.of<MessageBloc>(context).add(
                              SendMessage(message: newMessage),
                            );
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
              ),
            );
          },
        ),
      ),
    );
  }
}

bool isMessagesNullOrEmpty(List<Message?>? messages) {
  return messages == null || messages.isEmpty;
}
