import 'package:flutter/material.dart';

class SnackBarService {
  static void showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.white,
        content: Container(
          height: 40,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20)
          ),
          child: Text(
            message,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Theme.of(context).primaryColor),
          ),
        ),
      ),
    );
  }

  static void hideSnackBar(BuildContext context) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
  }

  static void replaceSnackBar(BuildContext context, String message) {
    hideSnackBar(context);
    showSnackBar(context, message);
  }

/*static void showFlushBar({required BuildContext context, required String message, String? title}) {
    Flushbar(
      backgroundColor: Colors.white,
      title: title,
      flushbarPosition: FlushbarPosition.TOP,
      message: message,
      duration: const Duration(seconds: 3),
    ).show(context);
  }*/
}