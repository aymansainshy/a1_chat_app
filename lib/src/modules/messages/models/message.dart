import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import '../../online-users/models/user_model.dart';

enum MessageType { text, media }

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
  late MessageType messageType;
  late String? uuid;
  late User? sender;
  late User? receiver;
  late String content;
  late DateTime createdAt;
  late bool isRead;
  late bool isSuccess;
  late bool isDelivered;
  late bool isNew;
  late DateTime? receivedAt;

  Message({
    this.id,
    required this.uuid,
    required this.sender,
    required this.receiver,
    required this.content,
    required this.createdAt,
    required this.receivedAt,
    required this.messageType,
    this.isRead = false,
    this.isDelivered = false,
    this.isSuccess = false,
    this.isNew = true,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'uuid': uuid,
      'message_type': messageType.toString(),
      'is_read': isRead,
      'is_success': isSuccess,
      'is_delivered': isDelivered,
      'is_new': isNew,
      'sender': {
        'id': sender?.id,
        'name': sender?.name,
        'phone_number': sender?.phoneNumber,
        'image_url': sender?.imageUrl,
      },
      'receiver': {
        'id': receiver?.id,
        'name': receiver?.name,
        'phone_number': receiver?.phoneNumber,
        'image_url': receiver?.imageUrl,
      },
      'content': content,
      'createdAt': createdAt.toIso8601String(),
      'receivedAt': receivedAt?.toIso8601String(),
    };
  }

  factory Message.fromJsonSocketIO(Map<String, dynamic> json) {
    return Message(
      id: json['id'].toString() ?? '',
      uuid: json['uuid'],
      messageType: json['message_type'] ?? MessageType.text,
      content: json['content'],
      isRead: json['is_read'],
      isSuccess: json['is_success'],
      isNew: json['is_new'],
      isDelivered: json['is_delivered'],
      createdAt: DateTime.parse(json['createdAt']),
      sender: User.fromJson(json['sender']),
      receiver: User.fromJson(json['receiver']),
      receivedAt: DateTime.now(),
    );
  }

  factory Message.fromJsonDb(Map<String, dynamic> json) {
    return Message(
      id: json['id'].toString() ?? '',
      uuid: json['uuid'],
      messageType: json['message_type'] ?? MessageType.text,
      content: json['content'],
      isRead: json['is_read'],
      isSuccess: json['is_success'],
      isNew: json['is_new'],
      isDelivered: json['is_delivered'],
      createdAt: DateTime.parse(json['createdAt']),
      sender: User.fromJson(json['sender']),
      receiver: User.fromJson(json['receiver']),
      receivedAt: DateTime.parse(json['receivedAt']),
    );
  }

  @override
  List<Object?> get props => [uuid];
}
