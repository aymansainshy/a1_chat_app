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
  late List<Message> messages;

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
  late bool isNew;
  late DateTime? receivedAt;

  Message({
    required this.id,
    required this.sender,
    required this.receiver,
    required this.content,
    required this.createdAt,
    required this.receivedAt,
    this.isRead = false,
    this.isDelivered = false,
    this.isReceive = false,
    this.isNew = true,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'isRead': isRead,
      'isReceive': isReceive,
      'isDelivered': isDelivered,
      'isNew': isNew,
      'sender': {
        'id': sender?.id,
        'name': sender?.name,
        'phoneNumber': sender?.phoneNumber,
        'imageUrl': sender?.imageUrl,
      },
      'receiver': {
        'id': receiver?.id,
        'name': receiver?.name,
        'phoneNumber': receiver?.phoneNumber,
        'imageUrl': receiver?.imageUrl,
      },
      'content': content,
      'createdAt': createdAt.toIso8601String(),
      'receivedAt': receivedAt?.toIso8601String(),
    };
  }

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      id: json['id'],
      content: json['content'],
      isRead: json['isRead'],
      isReceive: json['isReceive'],
      isNew: json['isNew'],
      isDelivered: json['isDelivered'],
      createdAt: DateTime.parse(json['createdAt']),
      sender: User.fromJson(json['sender']),
      receiver: User.fromJson(json['receiver']),
      receivedAt: DateTime.now(),
    );
  }

  factory Message.fromJsonDb(Map<String, dynamic> json) {
    return Message(
      id: json['id'],
      content: json['content'],
      isRead: json['isRead'],
      isReceive: json['isReceive'],
      isNew: json['isNew'],
      isDelivered: json['isDelivered'],
      createdAt: DateTime.parse(json['createdAt']),
      sender: User.fromJson(json['sender']),
      receiver: User.fromJson(json['receiver']),
      receivedAt: DateTime.parse(json['receivedAt']),
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
        isNew,
        receivedAt,
      ];
}
