part of 'current_weather_bloc.dart';

sealed class CurrentWeatherEvent {}

class OnGetCurrentWeather extends CurrentWeatherEvent {
  final String cityName;
  final bool hasImage;

  OnGetCurrentWeather(this.cityName, this.hasImage);
}

class OnInitialCurrentWeather extends CurrentWeatherEvent {}
