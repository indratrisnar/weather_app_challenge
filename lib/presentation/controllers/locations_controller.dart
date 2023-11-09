import 'package:flutter/material.dart';

class LocationsController {
  late AnimationController headerAnimation;
  late AnimationController searchAnimation;
  late AnimationController btnAddAnimation;
  late Animation<Offset> headerOffset;
  late Animation<Offset> searchOffset;
  late Animation<Offset> btnAddOffset;

  init({required TickerProvider vsync}) async {
    headerAnimation = AnimationController(
      vsync: vsync,
      duration: const Duration(milliseconds: 500),
    );
    searchAnimation = AnimationController(
      vsync: vsync,
      duration: const Duration(milliseconds: 500),
    );
    btnAddAnimation = AnimationController(
      vsync: vsync,
      duration: const Duration(milliseconds: 500),
    );

    headerOffset = Tween(
      begin: const Offset(0, -0.3),
      end: Offset.zero,
    ).animate(headerAnimation);
    searchOffset = Tween(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(searchAnimation);
    btnAddOffset = Tween(
      begin: const Offset(0, 0.5),
      end: Offset.zero,
    ).animate(btnAddAnimation);

    await Future.delayed(const Duration(milliseconds: 500));
    headerAnimation.forward(from: 0.0);
    await Future.delayed(const Duration(milliseconds: 900));
    btnAddAnimation.forward(from: 0.0);
  }

  openSearchBox() {
    headerAnimation.animateBack(0);
    searchAnimation.animateTo(
      1,
      curve: Curves.fastOutSlowIn,
    );
  }

  closeSearchBox() async {
    searchAnimation.animateBack(
      0.0,
      curve: Curves.fastOutSlowIn,
    );
    await Future.delayed(const Duration(milliseconds: 300));
    headerAnimation.animateTo(
      1,
      curve: Curves.fastOutSlowIn,
    );
  }

  dispose() {
    headerAnimation.dispose();
    searchAnimation.dispose();
    btnAddAnimation.dispose();
  }
}
