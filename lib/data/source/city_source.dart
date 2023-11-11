import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weather_forecast/data/models/city.dart';

class CitySource {
  CitySource(this._preferences);
  final SharedPreferences _preferences;

  static const _currentCityKey = 'current_city';
  static const _citiesKey = 'cities';

  Future<bool> setCurrentCity(City city) {
    String stringCity = jsonEncode(city.toJson());
    return _preferences.setString(_currentCityKey, stringCity);
  }

  City? getCurrentCity() {
    String? stringCity = _preferences.getString(_currentCityKey);
    if (stringCity != null) {
      Map mapCity = Map.from(jsonDecode(stringCity));
      City city = City.fromJson(mapCity);
      return city;
    }
    return null;
  }

  Future<bool> setCities(List<City> cities) {
    List<String> list = cities.map((e) => jsonEncode(e.toJson())).toList();
    return _preferences.setStringList(_citiesKey, list);
  }

  List<City>? getCities() {
    List<String>? list = _preferences.getStringList(_citiesKey);
    if (list != null) {
      List<City> cities = list.map((e) {
        return City.fromJson(
          Map.from(jsonDecode(e)),
        );
      }).toList();
      return cities;
    }
    return null;
  }

  addCity(City city) {
    List<City> list = getCities() ?? [];
    if (list.isEmpty) setCurrentCity(city);
    List<City> cities = [...list, city];
    cities.sort((a, b) => a.name!.compareTo(b.name!));
    setCities(cities);
  }

  removeCity(City city) {
    List<City> list = getCities() ?? [];
    List<City> cities = list.where((e) => e.name! != city.name).toList();
    cities.sort((a, b) => a.name!.compareTo(b.name!));
    setCities(cities);
  }
}
