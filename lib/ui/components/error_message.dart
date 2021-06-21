import 'package:flutter/material.dart';

void showErrorMessage(BuildContext context, String errorText) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      backgroundColor: Colors.red[900],
      content: Text(errorText, textAlign: TextAlign.center),
      behavior: SnackBarBehavior.floating,
    ),
  );
}
