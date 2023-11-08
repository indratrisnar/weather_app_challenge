import 'package:weather_forecast/api/api_key.dart';

// weatherApiKey from https://openweathermap.org/

class URLs {
  static String base = 'https://api.openweathermap.org/data/2.5';

  static String currentWeather(String city) =>
      '$base/weather?q=$city&appid=$weatherApiKey';
  static String hourlyWeather(String city) =>
      '$base/forecast?q=$city&appid=$weatherApiKey';

  static String weatherIcon(String code) =>
      'https://openweathermap.org/img/wn/$code@4x.png';
}
