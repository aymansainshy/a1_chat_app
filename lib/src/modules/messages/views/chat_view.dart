import 'package:a1_chat_app/src/modules/messages/message-bloc/message_bloc.dart';
import 'package:a1_chat_app/src/modules/messages/models/message.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../config/app_config.dart';
import '../widgets/text_message_widget.dart';

class ChatView extends StatefulWidget {
  const ChatView({
    Key? key,
    required this.messageRoom,
    required this.isMe,
    required this.message,
  }) : super(key: key);

  final MessageRoom messageRoom;
  final Message message;
  final bool isMe;

  @override
  State<ChatView> createState() => _ChatViewState();
}

class _ChatViewState extends State<ChatView> {
  TextEditingController _textEditingController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  String messageText = '';
  String? messageImage;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil screenUtil = ScreenUtil();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        toolbarHeight: 60,
        title: Text("${widget.messageRoom.name}"),
        backgroundColor: Theme.of(context).primaryColor,
        automaticallyImplyLeading: false,
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            context.pop();
          },
          icon: const Icon(
            Icons.arrow_back,
          ),
        ),
      ),
      body: BlocConsumer<MessageBloc, MessageBlocState>(
        listener: (context, messageState) {
          // if (messageState is SendMessageWithNotificationSuccess) {
          //   ScaffoldMessenger.maybeOf(context).showSnackBar(
          //       SnackBar(content: Text("تم ارسال اخر رسالة بنجاح")));
          // }
        },
        builder: (context, messageState) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                child: ListView.builder(
                  reverse: true,
                  itemCount: 54,
                  itemBuilder: (context, i) {
                    return TextMessageItem(
                      isMe: widget.isMe,
                      message: widget.message,
                      messageRoom: widget.messageRoom,
                    );
                  },
                ),
              ),
              Container(
                padding: const EdgeInsets.only(
                  top: 5,
                  bottom: 5,
                  left: 15,
                  right: 15,
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Form(
                        key: _formKey,
                        child: TextFormField(
                          maxLines: 4,
                          minLines: 1,
                          textDirection: TextDirection.ltr,
                          decoration: InputDecoration(
                            labelText: "  اكتب رسالتك...",
                            labelStyle: TextStyle(
                              fontSize: screenUtil.setSp(30),
                            ),
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
                            focusColor: Theme.of(context).accentColor,
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
                    InkWell(
                      child: Container(
                          height: 40,
                          width: 40,
                          padding: const EdgeInsets.all(8),
                          child: const Icon(Icons.location_off)),
                      onTap: () async {
                        var newMassege = Message(
                          id: DateTime.now().toString(),
                          sender: Application.user?.toString(),
                          receiver: Application.user?.toString(),
                          content: messageText,
                        );

                        // AppBlocs.chatMessagesBloc.add(SendMessage(chatMessage: newMassege));
                      },
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
