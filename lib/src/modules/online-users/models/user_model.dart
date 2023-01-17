import 'package:equatable/equatable.dart';

// ignore: must_be_immutable
class User extends Equatable {
  late String? id;
  late String? name;
  late String? phoneNumber;
  late String? imageUrl;
  late bool? isOnline;

  User({
    required this.id,
    required this.phoneNumber,
    this.name,
    this.imageUrl,
    this.isOnline = false,
  });

  @override
  List<Object?> get props => [id, name, phoneNumber, imageUrl, isOnline];
}
