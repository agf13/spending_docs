import 'package:flutter/material.dart'
    show
        BuildContext,
        showDialog,
        Widget,
        Text,
        Navigator,
        TextButton,
        AlertDialog;

class PopupHelper {
  static void showMessagePopup(
    BuildContext context,
    String title,
    String message,
  ) {
    showDialog(
      context: context,
      // Prevents the popup from closing if the user accidentally taps outside it
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                // Closes the popup and returns to the previous screen
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
