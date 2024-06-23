import 'package:flutter/material.dart';

class SnackBarMessage {
  static void showSnackBar(
      BuildContext context, String message, Color backgroundColor) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          content: Text(
            message,
          ),
          backgroundColor: backgroundColor),
    );
  }
}
