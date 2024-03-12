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

  static Widget formType(
    double heightScreen,
    String? initial,
    Function(String?) saved,
    Function(Object?)? custom,
  ) {
    return FormField(
      onSaved: saved,
      initialValue: initial,
      validator: (value) {
        if (value == null) {
          return 'Please choose income / expense';
        }
        return null;
      },
      builder: (field) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
              flex: 3,
              child: Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: GestureDetector(
                      onTap: () {
                        field.didChange('in');
                      },
                      child: Container(
                        height: heightScreen * 0.045,
                        decoration: BoxDecoration(
                          color: field.value == "in"
                              ? Colors.green[600]
                              : Colors.green[300],
                          // color: Colors.grey[200],
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(8),
                            bottomLeft: Radius.circular(8),
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Income",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: heightScreen * 0.015,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: GestureDetector(
                      onTap: () {
                        field.didChange('out');
                      },
                      child: Container(
                        height: heightScreen * 0.045,
                        decoration: BoxDecoration(
                          color: field.value == "out"
                              ? Colors.red[600]
                              : Colors.red[200],
                          // color: Colors.grey[200],
                          borderRadius: const BorderRadius.only(
                            topRight: Radius.circular(8),
                            bottomRight: Radius.circular(8),
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Expense",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: heightScreen * 0.015,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Text(
                  field.errorText ?? '',
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: heightScreen * 0.014,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
