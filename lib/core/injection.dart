import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weather_forecast/presentation/bloc/hourly_weather/hourly_weather_bloc.dart';
import 'package:weather_forecast/presentation/bloc/locations/locations_bloc.dart';
import 'package:weather_forecast/presentation/controllers/city_controller.dart';
import 'package:weather_forecast/data/source/city_source.dart';
import 'package:weather_forecast/data/source/weather_source.dart';
import 'package:http/http.dart' as http;
import '../presentation/bloc/current_weather/current_weather_bloc.dart';

final locator = GetIt.instance;

Future<void> initLocator() async {
  // bloc
  locator.registerFactory(() => CurrentWeatherBloc(locator()));
  locator.registerFactory(() => HourlyWeatherBloc(locator()));
  locator.registerFactory(() => CityController(locator()));
  locator.registerFactory(() => LocationsBloc(locator(), locator()));

  // source
  locator.registerLazySingleton(() => WeatherSource(locator()));
  locator.registerLazySingleton(() => CitySource(locator()));

  // external
  locator.registerLazySingleton(() => http.Client());
  final pref = await SharedPreferences.getInstance();
  locator.registerLazySingleton(() => pref);
}
