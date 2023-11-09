import 'package:flutter/material.dart';

class LocationsController {
  late AnimationController btnAddAnimation;
  late Animation<Offset> btnAddOffset;
  late AnimationController searchAnimation;

  init({
    required TickerProvider vsync,
  }) async {
    btnAddAnimation = AnimationController(
      vsync: vsync,
      duration: const Duration(milliseconds: 500),
    );
    searchAnimation = AnimationController(
      vsync: vsync,
      duration: const Duration(milliseconds: 500),
    );

    btnAddOffset = Tween(
      begin: const Offset(0.5, 0),
      end: Offset.zero,
    ).animate(btnAddAnimation);
  }

  reset() {
    btnAddAnimation.value = 0.0;
    searchAnimation.value = 0.0;
  }

  dispose() {
    btnAddAnimation.dispose();
    searchAnimation.dispose();
  }
}
