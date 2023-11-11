import 'package:blur/blur.dart';
import 'package:d_button/d_button.dart';
import 'package:d_view/d_view.dart';
import 'package:flutter/material.dart';

class ErrorRefreshWidget extends StatelessWidget {
  const ErrorRefreshWidget({
    super.key,
    required this.message,
    required this.onRefresh,
  });
  final String message;
  final VoidCallback onRefresh;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 30,
              vertical: 8,
            ),
            child: Text(
              message,
              style: const TextStyle(
                color: Colors.blueGrey,
                fontWeight: FontWeight.bold,
              ),
            ),
          ).frosted(
            blur: 1,
            borderRadius: BorderRadius.circular(30),
            frostColor: Colors.white.withOpacity(0.5),
          ),
          DView.height(),
          DButtonCircle(
            onClick: () => onRefresh(),
            diameter: 40,
            mainColor: Colors.white.withOpacity(0.3),
            child: const Icon(
              Icons.refresh,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
