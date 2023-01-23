import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import '../../online-users/models/user_model.dart';

@immutable
// ignore: must_be_immutable
class MessageRoom extends Equatable {
  late String? id;
  late User? user;
  late bool? isTyping;
  late bool? isOnline;
  late Message? lastMessage;
  late List<Message?>? messages;

  MessageRoom({
    required this.id,
    this.isTyping = false,
    this.messages = const [],
    this.lastMessage,
    required this.user,
    this.isOnline = false,
  });

  @override
  List<Object?> get props => [messages];

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'isTyping': isTyping,
      'lastMessage': {
        'id': lastMessage?.id,
        'sender': lastMessage?.sender,
        'receiver': lastMessage?.receiver,
        'content': lastMessage?.content,
        'isRead': lastMessage?.isRead,
        'isReceive': lastMessage?.isReceive,
        'isDelivered': lastMessage?.isDelivered,
      },
      'messages': List<Message>.from(
        messages!.map(
          (m) => {
            'id': m?.id,
            'sender': m?.sender,
            'receiver': m?.receiver,
            'content': m?.content,
            'isRead': m?.isRead,
            'isReceive': m?.isReceive,
            'isDelivered': m?.isDelivered,
          },
        ),
      ),
    };
  }
}

@immutable
// ignore: must_be_immutable
class Message extends Equatable {
  late String? id;
  late User? sender;
  late User? receiver;
  late String content;

  late DateTime createdAt;
  late bool isRead;
  late bool isReceive;
  late bool isDelivered;

  Message({
    required this.id,
    required this.sender,
    required this.receiver,
    required this.content,
    required this.createdAt,
    this.isRead = false,
    this.isDelivered = false,
    this.isReceive = false,
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      id: json['id'],
      content: json['content'],
      createdAt: json['createdAt'],
      sender: User.fromJson(json['sender']),
      receiver: User.fromJson(json['receiver']),
    );
  }

  @override
  List<Object?> get props => [
        id,
        sender,
        receiver,
        content,
        isReceive,
        isDelivered,
        isRead,
      ];
}

class MessageUser {
  late String? id;
  late String? name;
  late String? imageUrl;
  late String? phoneNumber;

  MessageUser({
    required this.id,
    this.name,
    this.imageUrl,
    required this.phoneNumber,
  });
}
