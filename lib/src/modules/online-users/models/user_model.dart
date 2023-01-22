import 'package:equatable/equatable.dart';

// ignore: must_be_immutable
class User extends Equatable {
  late String? id;
  late String? name;
  late String? phoneNumber;
  late String? imageUrl;
  late String? token;

  User({
    required this.id,
    required this.phoneNumber,
    this.name,
    this.imageUrl,
    this.token,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'phoneNumber': phoneNumber,
      'imageUrl': imageUrl,
      'token': token,
    };
  }

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["id"],
        name: json["name"],
        phoneNumber: json["phoneNumber"],
        imageUrl: json["imageUrl"],
        token: json["token"],
      );

  @override
  List<Object?> get props => [id, name, phoneNumber, imageUrl, token];
}
