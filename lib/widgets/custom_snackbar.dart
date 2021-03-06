import 'package:flutter/material.dart';

class CustomSnackBar {
  CustomSnackBar(
    BuildContext context, {
    required String text,
    String? title,
    int? duration,
  }) {
    final snackBar = SnackBar(
      content: Text(text),
      duration: Duration(seconds: duration ?? 10),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
