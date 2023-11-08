import 'package:shared_preferences/shared_preferences.dart';

class CitySource {
  CitySource(this.preferences);
  final SharedPreferences preferences;

  static const _currentCityKey = 'current_city';
  static const _citiesKey = 'cities';

  Future<bool> cacheCurrentCity(String city) {
    return preferences.setString(_currentCityKey, city);
  }

  String? getCurrentCity() {
    return preferences.getString(_currentCityKey);
  }

  Future<bool> cacheCities(List<String> cities) {
    return preferences.setStringList(_citiesKey, cities);
  }

  List<String>? getCities() {
    return preferences.getStringList(_citiesKey);
  }
}
