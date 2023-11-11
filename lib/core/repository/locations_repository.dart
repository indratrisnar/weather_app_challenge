import 'package:weather_forecast/data/models/weather.dart';

// data is retained but not directly displayed to the ui
// so, not always access looping request to api
// for modify locations bloc
class LocationRepository {
  static List<Weather> savedLocations = [];

  static Future<void> add(Weather weather) async {
    savedLocations = [weather, ...savedLocations];
  }

  static remove(Weather weather) {
    savedLocations = List.from(
      savedLocations.where((e) => e.city.name != weather.city.name).toList(),
    );
  }
}
