import 'package:d_view/d_view.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:weather_forecast/presentation/widgets/load_box.dart';

class CurrentWeatherShimmer extends StatelessWidget {
  const CurrentWeatherShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    Color baseColor = Colors.white54;
    Color highlightColor = Colors.grey;
    return Shimmer.fromColors(
      baseColor: baseColor,
      highlightColor: highlightColor,
      child: Column(
        children: [
          // november 8
          const LoadBox(height: 30, width: 120),
          DView.height(8),
          // updated as...
          const LoadBox(height: 15, width: 250),
          DView.height(20),
          // icon
          const LoadBox(height: 80, width: 80),
          DView.height(20),
          // main
          const LoadBox(height: 36, width: 100),
          DView.height(8),
          // description
          const LoadBox(height: 18, width: 130),
          DView.height(30),
          // temperature
          const LoadBox(height: 90, width: 90),
          DView.height(40),
          GridView.count(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            crossAxisCount: 4,
            crossAxisSpacing: 8,
            padding: const EdgeInsets.all(0),
            children: List.generate(
              4,
              (index) => Column(
                children: [
                  const LoadBox(height: 30, width: 30),
                  DView.height(10),
                  const LoadBox(height: 16, width: 70),
                  DView.height(6),
                  const LoadBox(height: 14, width: 70),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
