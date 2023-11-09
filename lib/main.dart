import 'package:d_view/d_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:weather_forecast/commons/app_route.dart';
import 'package:weather_forecast/presentation/bloc/current_weather/current_weather_bloc.dart';
import 'package:weather_forecast/presentation/bloc/hourly_weather/hourly_weather_bloc.dart';
import 'package:weather_forecast/presentation/bloc/locations/locations_bloc.dart';

import 'injection.dart';
import 'presentation/controllers/city_controller.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  DView.defaultSpace = 20;
  await initLocator();
  Get.put(locator<CityController>());
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => locator<CurrentWeatherBloc>()),
        BlocProvider(create: (context) => locator<HourlyWeatherBloc>()),
        BlocProvider(create: (context) => locator<LocationsBloc>()),
      ],
      child: MaterialApp(
        theme: ThemeData.light(
          useMaterial3: true,
        ).copyWith(
          textTheme: GoogleFonts.poppinsTextTheme(),
          primaryColor: Colors.blueGrey,
          colorScheme: const ColorScheme.light(primary: Colors.blueGrey),
        ),
        debugShowCheckedModeBanner: false,
        onGenerateRoute: AppRoute.generate,
      ),
    );
  }
}
