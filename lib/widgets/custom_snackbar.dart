import 'package:flutter/material.dart';

class CustomSnackBar {
  CustomSnackBar(
    BuildContext context, {
    @required String text,
    String title,
  }) {
    final snackBar = SnackBar(content: Text(text));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
