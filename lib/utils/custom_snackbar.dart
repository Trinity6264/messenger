import 'package:flutter/material.dart';

void customSnack(String name, BuildContext context) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      dismissDirection: DismissDirection.startToEnd,
      duration: const Duration(seconds: 2),
      content: Text(name),
    ),
  );
}
