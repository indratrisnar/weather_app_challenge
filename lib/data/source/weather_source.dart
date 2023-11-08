import 'dart:convert';

import 'package:d_method/d_method.dart';
import 'package:dartz/dartz.dart';
import 'package:weather_forecast/api/urls.dart';
import 'package:weather_forecast/data/models/weather.dart';
import 'package:http/http.dart' as http;

class WeatherSource {
  final http.Client client;

  WeatherSource(this.client);

  Future<Either<String, Weather>> getCurrentWeather(String city) async {
    Uri url = Uri.parse(URLs.currentWeather(city));
    try {
      final response = await client.get(url);
      // DMethod.printResponse(response);
      if (response.statusCode == 200) {
        Weather weather = Weather.fromJson(jsonDecode(response.body));
        return Right(weather);
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
      // DMethod.printResponse(response);
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
    List<String> cities,
  ) async {
    try {
      List<Weather> list = [];
      for (String city in cities) {
        final result = await getCurrentWeather(city);
        result.fold((err) => null, (data) => list.add(data));
      }
      return Right(list);
    } catch (e) {
      DMethod.printTitle('exception: $this', e.toString());
      return const Left('Something went wrong');
    }
  }
}
