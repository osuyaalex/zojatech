import 'package:flutter/material.dart';

class IconButtonWidget extends StatelessWidget {
  final VoidCallback? onPressed;
  final Icon icon;
  const IconButtonWidget({super.key, required this.onPressed, required this.icon});

  @override
  Widget build(BuildContext context) {
    return IconButton(
        onPressed:onPressed,
        icon: icon
    );
  }
}
