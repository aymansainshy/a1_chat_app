import 'package:equatable/equatable.dart';

class Message extends Equatable {
  final String? id;
  final String? sender;
  final String? receiver;
  final String content;
  final bool isRead;
  final bool isReceive;
  final bool isDelivered;

  const Message({
    required this.id,
    required this.sender,
    required this.receiver,
    required this.content,
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

class MessageRoom extends Equatable {
  final String? id;
  final String? name;
  final String? imageUrl;
  final String? phoneNumber;
  final bool? isTyping;

  const MessageRoom({
    required this.id,
    this.isTyping = false,
    this.name,
    this.imageUrl,
    this.phoneNumber,
  });

  @override
  List<Object?> get props => [id];
}
