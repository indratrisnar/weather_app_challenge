import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:weather_forecast/api/urls.dart';
import 'package:weather_forecast/data/models/weather.dart';

class ItemHourly extends StatelessWidget {
  const ItemHourly({super.key, required this.weather});
  final Weather weather;

  @override
  Widget build(BuildContext context) {
    String time = DateFormat('h:mm').format(weather.dateTime);
    String a = DateFormat('a').format(weather.dateTime);

    return SizedBox(
      width: 60,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            time,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
            ),
          ),
          Text(
            a,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 10,
            ),
          ),
          ExtendedImage.network(
            URLs.weatherIcon(weather.icon),
            height: 70,
          ),
          Transform.translate(
            offset: const Offset(0, -10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  ' ${(weather.temperature - 273.15).round()}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    shadows: [
                      Shadow(
                        color: Colors.black38,
                        blurRadius: 6,
                      ),
                    ],
                  ),
                ),
                const Text(
                  '°',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    shadows: [
                      Shadow(
                        color: Colors.black38,
                        blurRadius: 6,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Text(
            '${(weather.wind * 3.6).toStringAsFixed(2)}\nkm/h',
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}
