import 'package:equatable/equatable.dart';


// ignore: must_be_immutable
class User extends Equatable {
  late String? id;
  late String? name;
  late String? phoneNumber;
  late String? imageUrl;
  late String? token;
  late String? socketId;
  late DateTime? lastSeen;

  User({
    required this.id,
    required this.phoneNumber,
    this.name,
    this.imageUrl,
    this.token,
    this.socketId,
    this.lastSeen,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'phone_number': phoneNumber,
      'image_Url': imageUrl,
      'socketId': socketId,
      'token': token,
      'lastSeen' : lastSeen?.toIso8601String(),
    };
  }

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["id"].toString(),
        name: json["name"],
        phoneNumber: json["phone_number"],
        imageUrl: json["image_Url"],
        token: json["token"] ?? '',
        lastSeen: DateTime.now(),
        socketId: json["socketId"] ?? '',
      );

  @override
  List<Object?> get props => [id, phoneNumber];
}
