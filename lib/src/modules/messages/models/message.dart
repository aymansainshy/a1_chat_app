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
  late Message? lastMessage;
  late List<Message?>? messages;

  MessageRoom({
    required this.id,
    this.isTyping = false,
    this.messages = const [],
    this.lastMessage,
    this.name,
    this.imageUrl,
    this.phoneNumber,
  });

  @override
  List<Object?> get props => [messages];
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
