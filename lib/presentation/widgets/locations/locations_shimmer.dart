import 'package:d_view/d_view.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:weather_forecast/presentation/widgets/load_box.dart';

class LocationShimmer extends StatelessWidget {
  const LocationShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    Color baseColor = Colors.white54;
    Color highlightColor = Colors.grey;
    return ListView.builder(
      itemCount: 3,
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(0),
      itemBuilder: (context, index) {
        return Container(
          margin: EdgeInsets.only(
            top: 10,
            bottom: index == 4 ? 20 : 10,
            left: 20,
            right: 20,
          ),
          decoration: BoxDecoration(
            color: Colors.blueGrey.withOpacity(0.3),
            borderRadius: BorderRadius.circular(20),
          ),
          padding: const EdgeInsets.all(20),
          child: Shimmer.fromColors(
            baseColor: baseColor,
            highlightColor: highlightColor,
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // city
                      const LoadBox(height: 28, width: 80),
                      DView.height(8),
                      // main
                      const LoadBox(height: 18, width: 70),
                      DView.height(),
                      Row(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const LoadBox(height: 16, width: 90),
                              DView.height(4),
                              const LoadBox(height: 16, width: 40),
                            ],
                          ),
                          DView.width(10),
                          const LoadBox(height: 32, width: 1.5),
                          DView.width(10),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const LoadBox(height: 16, width: 50),
                              DView.height(4),
                              const LoadBox(height: 16, width: 90),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const LoadBox(height: 30, width: 40),
                    DView.height(20),
                    const LoadBox(height: 50, width: 60),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
