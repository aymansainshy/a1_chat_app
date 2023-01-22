import 'package:flutter/material.dart';

class UserAvatar extends StatelessWidget {
  const UserAvatar({
    Key? key,
    this.imageUrl,
    this.radius = 35,
    this.isOnline = false,
    this.pos1 = 3,
    this.pos2 = 1,
  }) : super(key: key);

  final String? imageUrl;
  final bool isOnline;
  final double radius;
  final double pos1;
  final double pos2;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        if (imageUrl == null || imageUrl == "")
          CircleAvatar(
            radius: radius,
            backgroundColor: Theme.of(context).primaryColor,
            child: const Icon(Icons.person_add ),
          ),
        if (imageUrl != null && imageUrl != "")
          CircleAvatar(
            radius: radius,
            backgroundColor: Theme.of(context).primaryColor,
            backgroundImage: NetworkImage(
              imageUrl!
              // scale: 10.0,
            ),
          ),
        if (isOnline)
          Positioned(
            bottom: pos1,
            right: pos2,
            child: const CircleAvatar(
              radius: 6.5,
              backgroundColor: Colors.white,
              child: CircleAvatar(
                radius: 4.5,
                backgroundColor: Color.fromARGB(255, 53, 228, 9),
              ),
            ),
          )
      ],
    );
  }
}
