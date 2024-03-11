import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ComponentCustom {
  static final ComponentCustom instance = ComponentCustom();
  static void messageDialog(
    String title,
    String message,
    Function() event,
    BuildContext context,
  ) {
    showDialog(
      context: context,
      builder: (BuildContext context) => CupertinoAlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          CupertinoDialogAction(
            isDefaultAction: true,
            onPressed: event,
            child: const Text("Close"),
          )
        ],
      ),
    );
  }

  static void confirmationDialog(
    String title,
    String message,
    Function() event,
    BuildContext context,
  ) {
    showDialog(
      context: context,
      builder: (BuildContext context) => CupertinoAlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          CupertinoDialogAction(
            onPressed: event,
            child: const Text("Yes"),
          ),
          CupertinoDialogAction(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text("No"),
          )
        ],
      ),
    );
  }
}
