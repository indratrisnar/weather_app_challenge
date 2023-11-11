import 'dart:convert';

import 'package:d_method/d_method.dart';
import 'package:dartz/dartz.dart';
import 'package:weather_forecast/api/urls.dart';
import 'package:weather_forecast/data/models/city.dart';
import 'package:weather_forecast/data/models/weather.dart';
import 'package:http/http.dart' as http;

class WeatherSource {
  final http.Client client;

  WeatherSource(this.client);

  Future<Either<String, Weather>> getCurrentWeather(
    String cityName,
    bool hasImage,
  ) async {
    Uri url = Uri.parse(URLs.currentWeather(cityName));
    try {
      final response = await client.get(url);
      // DMethod.logResponse(response);
      if (response.statusCode == 200) {
        Weather weather = Weather.fromJson(
          jsonDecode(response.body),
          hasImage: hasImage,
        );
        return Right(weather);
      } else if (response.statusCode == 404) {
        return const Left('City not found');
      } else {
        return const Left('Fetch data error');
      }
    } catch (e) {
      DMethod.printTitle('exception: $this', e.toString());
      return const Left('Something went wrong');
    }
  }

  Future<Either<String, List<Weather>>> getHourlyWeather(
    String city,
  ) async {
    Uri url = Uri.parse(URLs.hourlyWeather(city));
    try {
      final response = await client.get(url);
      // DMethod.logResponse(response);
      if (response.statusCode == 200) {
        Map resBody = jsonDecode(response.body);
        List weatherList = resBody['list'];
        List<Weather> weathers = weatherList
            .take(20)
            .map((e) => Weather.fromJson(Map.from(e)))
            .toList();
        return Right(weathers);
      } else {
        return const Left('Fetch data error');
      }
    } catch (e) {
      DMethod.printTitle('exception: $this', e.toString());
      return const Left('Something went wrong');
    }
  }

  Future<Either<String, List<Weather>>> getLocationsWeather(
    List<City> cities,
  ) async {
    try {
      List<Weather> list = [];
      for (City city in cities) {
        Uri url = Uri.parse(URLs.currentWeather(city.name!));
        final response = await client.get(url);
        // DMethod.logResponse(response);
        if (response.statusCode == 200) {
          Weather weather = Weather.fromJson(
            jsonDecode(response.body),
            hasImage: city.hasImage,
          );
          list.add(weather);
        }
      }
      return Right(list);
    } catch (e) {
      DMethod.printTitle('exception: $this', e.toString());
      return const Left('Something went wrong');
    }
  }
}
