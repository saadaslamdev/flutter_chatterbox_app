import 'package:flutter/material.dart';

class SnackBarComponent {
  static void showSnackBar(
      BuildContext context, String message, Color backgroundColor) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
        ),
        backgroundColor: backgroundColor,
        showCloseIcon: true,
      ),
    );
  }
}
