part of 'current_weather_bloc.dart';

sealed class CurrentWeatherEvent {}

class OnGetCurrentWeather extends CurrentWeatherEvent {
  final String city;

  OnGetCurrentWeather(this.city);
}

class OnInitialCurrentWeather extends CurrentWeatherEvent {}
