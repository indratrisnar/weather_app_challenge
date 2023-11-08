part of 'hourly_weather_bloc.dart';

sealed class HourlyWeatherState {}

final class HourlyWeatherInitial extends HourlyWeatherState {}

final class HourlyWeatherLoading extends HourlyWeatherState {}

final class HourlyWeatherError extends HourlyWeatherState {
  final String message;

  HourlyWeatherError(this.message);
}

final class HourlyWeatherLoaded extends HourlyWeatherState {
  final List<Weather> weathers;

  HourlyWeatherLoaded(this.weathers);
}
