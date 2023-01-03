import 'package:equatable/equatable.dart';

class Message extends Equatable {
  final String? id;
  final String? sender;
  final String? receiver;
  // final MessageRoom messageRoom;
  final String content;

  const Message({
    required this.id,
    required this.sender,
    required this.receiver,
    // required this.messageRoom,
    required this.content,
  });
  
  @override
  List<Object?> get props => [id,sender,receiver,content];
}

class MessageRoom extends Equatable {
  final String? id;
  final String? name;
  final String? imageUrl;
  final String? phoneNumber;

  const MessageRoom({
    required this.id,
    this.name,
    this.imageUrl,
    this.phoneNumber,
  });
  
  @override
  List<Object?> get props => [id,name];
}
