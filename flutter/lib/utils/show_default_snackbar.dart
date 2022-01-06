import 'package:flutter/material.dart';

void showDefaultSnackBar({
  required String content,
  required BuildContext context,
}) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(content)));
}
