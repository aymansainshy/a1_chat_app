import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

@immutable
// ignore: must_be_immutable
class MessageRoom extends Equatable {
  late String? id;
  late String? name;
  late String? imageUrl;
  late String? phoneNumber;
  late bool? isTyping;
  late bool? isOnline;
  late Message? lastMessage;
  late List<Message?>? messages;

  MessageRoom({
    required this.id,
    this.isTyping = false,
    this.messages = const [],
    this.lastMessage,
    this.name,
    this.imageUrl,
    this.isOnline = false,
    required this.phoneNumber,
  });

  @override
  List<Object?> get props => [messages];

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'imageUrl': imageUrl,
      'phoneNumber': phoneNumber,
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
  late String? sender;
  late String? receiver;
  late String content;

  // final DateTime createdAt;
  late bool isRead;
  late bool isReceive;
  late bool isDelivered;

  Message({
    required this.id,
    required this.sender,
    required this.receiver,
    required this.content,
    // required this.createdAt,
    this.isRead = false,
    this.isDelivered = false,
    this.isReceive = false,
  });

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
