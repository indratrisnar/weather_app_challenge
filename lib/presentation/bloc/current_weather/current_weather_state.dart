part of 'current_weather_bloc.dart';

sealed class CurrentWeatherState {}

final class CurrentWeatherInitial extends CurrentWeatherState {}

final class CurrentWeatherLoading extends CurrentWeatherState {}

final class CurrentWeatherError extends CurrentWeatherState {
  final String message;

  CurrentWeatherError(this.message);
}

final class CurrentWeatherLoaded extends CurrentWeatherState {
  final Weather weather;

  CurrentWeatherLoaded(this.weather);
}
