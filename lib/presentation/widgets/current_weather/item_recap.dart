import 'package:d_view/d_view.dart';
import 'package:flutter/material.dart';

class ItemRecap extends StatelessWidget {
  const ItemRecap(this.icon, this.title, this.data, {super.key});
  final IconData icon;
  final String title;
  final String data;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Icon(
          icon,
          size: 30,
          color: Colors.white,
        ),
        DView.height(8),
        Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
            shadows: [
              Shadow(
                color: Colors.black38,
                blurRadius: 6,
              ),
            ],
          ),
        ),
        DView.height(4),
        Text(
          data,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 14,
            shadows: [
              Shadow(
                color: Colors.black38,
                blurRadius: 6,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
