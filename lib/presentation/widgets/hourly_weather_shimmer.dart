import 'package:d_view/d_view.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import 'load_box.dart';

class HourlyWeatherShimmer extends StatelessWidget {
  const HourlyWeatherShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    Color baseColor = Colors.grey[700]!;
    Color highlightColor = Colors.grey;
    return Shimmer.fromColors(
      baseColor: baseColor,
      highlightColor: highlightColor,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.all(16),
        children: [
          const LoadBox(height: double.infinity, width: 50),
          ...List.generate(5, (index) {
            return Padding(
              padding: const EdgeInsets.only(left: 36),
              child: Column(
                children: [
                  // time
                  const LoadBox(height: 14, width: 40),
                  DView.height(2),
                  // unit
                  const LoadBox(height: 10, width: 16),
                  DView.height(20),
                  // icon
                  const LoadBox(height: 40, width: 45),
                  DView.height(20),
                  // temperature
                  const LoadBox(height: 24, width: 24),
                  DView.height(8),
                  // wind
                  const LoadBox(height: 10, width: 20),
                  DView.height(2),
                  // unit
                  const LoadBox(height: 10, width: 24),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}
