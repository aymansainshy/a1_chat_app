class Message {
  final String? id;
  final String? sender;
  final String? receiver;
  // final MessageRoom messageRoom;
  final String content;

  Message({
    required this.id,
    required this.sender,
    required this.receiver,
    // required this.messageRoom,
    required this.content,
  });
}

class MessageRoom {
  final String? id;
  final String? name;
  final String? imageUrl;
  final String? phoneNumber;

  MessageRoom({
    required this.id,
    this.name,
    this.imageUrl,
    this.phoneNumber,
  });
}
