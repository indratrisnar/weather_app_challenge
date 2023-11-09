import 'dart:async';

import 'package:flutter/material.dart';

class CurrentWeatherController {
  late AnimationController dateMonthAnimation;
  late AnimationController updatedAnimation;
  late AnimationController iconAnimation;
  late AnimationController mainAnimation;
  late AnimationController descriptionAnimation;
  late AnimationController temperatureAnimation;
  late AnimationController humidityAnimation;
  late AnimationController pressureAnimation;
  late AnimationController windAnimation;
  late AnimationController feelsLikeAnimation;
  late AnimationController hourlyAnimation;

  init({
    required TickerProvider vsync,
  }) async {
    dateMonthAnimation = AnimationController(
      vsync: vsync,
      duration: const Duration(milliseconds: 500),
    );
    updatedAnimation = AnimationController(
      vsync: vsync,
      duration: const Duration(milliseconds: 500),
    );
    iconAnimation = AnimationController(
      vsync: vsync,
      duration: const Duration(milliseconds: 500),
    );
    mainAnimation = AnimationController(
      vsync: vsync,
      duration: const Duration(milliseconds: 500),
    );
    descriptionAnimation = AnimationController(
      vsync: vsync,
      duration: const Duration(milliseconds: 500),
    );
    temperatureAnimation = AnimationController(
      vsync: vsync,
      duration: const Duration(milliseconds: 500),
    );
    humidityAnimation = AnimationController(
      vsync: vsync,
      duration: const Duration(milliseconds: 500),
    );
    pressureAnimation = AnimationController(
      vsync: vsync,
      duration: const Duration(milliseconds: 500),
    );
    windAnimation = AnimationController(
      vsync: vsync,
      duration: const Duration(milliseconds: 500),
    );
    feelsLikeAnimation = AnimationController(
      vsync: vsync,
      duration: const Duration(milliseconds: 500),
    );
    hourlyAnimation = AnimationController(
      vsync: vsync,
      duration: const Duration(milliseconds: 500),
    );
  }

  reset() {
    dateMonthAnimation.value = 0.0;
    updatedAnimation.value = 0.0;
    iconAnimation.value = 0.0;
    mainAnimation.value = 0.0;
    descriptionAnimation.value = 0.0;
    temperatureAnimation.value = 0.0;
    humidityAnimation.value = 0.0;
    pressureAnimation.value = 0.0;
    windAnimation.value = 0.0;
    feelsLikeAnimation.value = 0.0;
    hourlyAnimation.value = 0.0;
  }

  execute() async {
    dateMonthAnimation.forward(from: 0.0);
    await Future.delayed(const Duration(milliseconds: 200));
    updatedAnimation.forward(from: 0.0);
    await Future.delayed(const Duration(milliseconds: 200));
    iconAnimation.forward(from: 0.0);
    await Future.delayed(const Duration(milliseconds: 200));
    mainAnimation.forward(from: 0.0);
    await Future.delayed(const Duration(milliseconds: 200));
    descriptionAnimation.forward(from: 0.0);
    await Future.delayed(const Duration(milliseconds: 200));
    temperatureAnimation.forward(from: 0.0);
    await Future.delayed(const Duration(milliseconds: 200));
    humidityAnimation.forward(from: 0.0);
    await Future.delayed(const Duration(milliseconds: 200));
    pressureAnimation.forward(from: 0.0);
    await Future.delayed(const Duration(milliseconds: 200));
    windAnimation.forward(from: 0.0);
    await Future.delayed(const Duration(milliseconds: 200));
    feelsLikeAnimation.forward(from: 0.0);

    // start with dateMonthAnimation
    // await Future.delayed(const Duration(milliseconds: 200 * 11));
    hourlyAnimation.forward(from: 0.0);
  }

  dispose() {
    dateMonthAnimation.dispose();
    updatedAnimation.dispose();
    iconAnimation.dispose();
    mainAnimation.dispose();
    descriptionAnimation.dispose();
    temperatureAnimation.dispose();
    humidityAnimation.dispose();
    pressureAnimation.dispose();
    windAnimation.dispose();
    feelsLikeAnimation.dispose();
    hourlyAnimation.dispose();
  }
}
