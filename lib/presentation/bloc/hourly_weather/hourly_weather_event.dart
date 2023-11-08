part of 'hourly_weather_bloc.dart';

sealed class HourlyWeatherEvent {}

class OnGetHourlyWeather extends HourlyWeatherEvent {
  final String city;

  OnGetHourlyWeather(this.city);
}

class OnInitialHourlyWeather extends HourlyWeatherEvent {}
