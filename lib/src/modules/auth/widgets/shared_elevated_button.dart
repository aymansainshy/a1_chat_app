import 'package:flutter/material.dart';

import '../../../core/constan/const.dart';

class SharedElevatedButton extends StatelessWidget {
  const SharedElevatedButton({
    required this.child,
    required this.onPressed,
    Key? key,
  }) : super(key: key);

  final void Function()? onPressed;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ButtonStyle(
        padding: MaterialStateProperty.all<EdgeInsets>(
          EdgeInsets.zero,
        ),
        // backgroundColor: MaterialStateProperty.all<Color>(
        //   Theme.of(context).colorScheme.secondary,
        // ),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(kborderRaduios),
            // side: BorderSide(color: Colors.red)
          ),
        ),
      ),
      onPressed: onPressed,
      child: Ink(
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor,
          borderRadius: const BorderRadius.all(Radius.circular(kborderRaduios)),
        ),
        child: child,
      ),
    );
  }
}
