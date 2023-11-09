import 'package:flutter/material.dart';

import '../presentation/pages/current_weather_page.dart';
import '../presentation/pages/locations_page.dart';

class AppRoute {
  static String locations = '/locations';

  static Route<dynamic>? generate(RouteSettings settings) {
    if (settings.name == '/') {
      return PageRouteBuilder(
        // transitionsBuilder: (context, animation, secondaryAnimation, child) {
        //   const Offset begin = Offset(0, 1);
        //   const Offset end = Offset.zero;
        //   final Tween<Offset> tween = Tween(begin: begin, end: end);
        //   final Animation<Offset> offsetAnimation = animation.drive(tween);
        //   return SlideTransition(
        //     position: offsetAnimation,
        //     child: child,
        //   );
        // },
        transitionDuration: const Duration(milliseconds: 1200),
        pageBuilder: (context, animation, secondaryAnimation) {
          return const CurrentWeatherPage();
        },
      );
    }
    if (settings.name == locations) {
      return PageRouteBuilder(
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(1, 0);
          const end = Offset.zero;
          final tween = Tween(begin: begin, end: end);
          final curvedAnimation = CurvedAnimation(
            parent: animation,
            curve: Curves.easeOutExpo,
          );
          return SlideTransition(
            position: tween.animate(curvedAnimation),
            child: child,
          );
        },
        transitionDuration: const Duration(milliseconds: 1200),
        reverseTransitionDuration: const Duration(milliseconds: 500),
        pageBuilder: (context, animation, secondaryAnimation) {
          return const LocationsPage();
        },
      );
    }
    return MaterialPageRoute(
      builder: (context) => const Scaffold(
        body: Center(child: Text('Page Not Found')),
      ),
    );
  }
}
