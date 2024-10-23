import 'package:flutter/material.dart';

class Helpers {
  // Show a simple alert dialog
  static void showAlertDialog(
      BuildContext context, String title, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  // Format date to a readable string
  static String formatDate(DateTime date) {
    return "${date.day}/${date.month}/${date.year}";
  }

  // Validate email format
  static bool isValidEmail(String email) {
    final RegExp regex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    return regex.hasMatch(email);
  }
}
