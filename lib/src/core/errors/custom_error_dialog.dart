import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart' as dialog;

customeAlertDialoge({
  BuildContext? context,
  Function? fun,
  String? title,
  String? errorMessage,
  String? imageUrl,
  String? sendOtptitle,
  dialog.AlertType? alertType,
}) {
  return dialog.Alert(
    context: context!,
    style: dialog.AlertStyle(
      animationType: dialog.AnimationType.grow,
      isCloseButton: true,
      isOverlayTapDismiss: false,
      descStyle: const TextStyle(
        // fontWeight: FontWeight.bold,
        fontSize: 12,
      ),
      descTextAlign: TextAlign.center,
      animationDuration: const Duration(milliseconds: 400),
      alertBorder: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      titleStyle: const TextStyle(
        color: Colors.red,
        fontSize: 13,
      ),
      alertAlignment: Alignment.center,
    ),
    type: imageUrl == null ? alertType ?? dialog.AlertType.warning : null,
    title: "$title",
    desc: "$errorMessage",
    image: imageUrl == null
        ? null
        : Image.asset(
            imageUrl,
            color: Colors.blue[700],
          ),
    buttons: [
      dialog.DialogButton(
        onPressed: () {
          Navigator.pop(context);
          fun!();
        },
        color: Colors.white,
        radius: BorderRadius.circular(8.0),
        child: Text(
          sendOtptitle ?? "Ok",
          style: const TextStyle(color: Colors.white, fontSize: 12),
        ),
      ),
    ],
  ).show();
}

Future simpleErrorDialog(BuildContext context, Function? fun) {
  return showDialog(
    context: context,
    builder: (context) => GestureDetector(
      onTap: () {},
      behavior: HitTestBehavior.opaque,
      child: AlertDialog(
        title: const Text(
          "An error accured",
          style: TextStyle(
            color: Colors.black,
            fontSize: 14,
          ),
        ),
        actions: [
          MaterialButton(
            onPressed: () {
              Navigator.of(context).pop();
              fun!();
            },
            child: const Text(
              "Ok",
              style: TextStyle(
                color: Colors.green,
                fontSize: 12,
              ),
            ),
          )
        ],
      ),
    ),
  );
}
