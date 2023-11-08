import 'package:flutter/material.dart';

class LoadBox extends StatelessWidget {
  const LoadBox({super.key, required this.height, required this.width});
  final double height;
  final double width;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6),
        color: Colors.black,
      ),
    );
  }
}
