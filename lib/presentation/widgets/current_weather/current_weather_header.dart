import 'package:d_view/d_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';

import '../../controllers/city_controller.dart';

class CurrentWeatherHeader extends StatelessWidget {
  const CurrentWeatherHeader({
    super.key,
    required this.cityController,
    required this.menuOnPressed,
  });
  final CityController cityController;
  final VoidCallback menuOnPressed;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Icon(
          Icons.location_on,
          size: 30,
          color: Colors.white,
        ),
        DView.width(4),
        Obx(
          () {
            String cityName = cityController.currentCity;
            return Hero(
              tag: 'city_name_tag_$cityName',
              child: Material(
                color: Colors.transparent,
                child: Text(
                  cityName == '' ? 'City is not setup' : cityName,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    shadows: [
                      Shadow(
                        color: Colors.black,
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
        const Spacer(),
        IconButton(
          onPressed: menuOnPressed,
          icon: const Icon(
            Icons.menu,
            color: Colors.white,
            size: 30,
          ),
        ),
      ],
    );
  }
}
