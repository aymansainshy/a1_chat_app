class User {
  late String? id;
  late String? phoneNumber;
  late String? imageUrl;
  late bool? isOnline;

  User({
    required this.id,
    required this.phoneNumber,
    this.imageUrl,
    this.isOnline = false,
  });
}
