import 'package:flutter/material.dart';

void snack(BuildContext context, String title) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      showCloseIcon: true,
      closeIconColor: Colors.green,
      duration: const Duration(seconds: 5),
      content: Text(title),
      behavior: SnackBarBehavior.floating,
      // Provide a unique tag for each SnackBar instance
      // by appending the current timestamp to the title
      key: ValueKey<String>(title + DateTime.now().toString()),
    ),
  );
}