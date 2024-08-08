import 'package:flutter/material.dart';

class Space extends StatelessWidget {
  final double height;
  const Space({super.key, required this.height});

  @override
  Widget build(BuildContext context) {
    return SizedBox(height: height,);
  }
}
