import 'package:weather_forecast/models/weather.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_forecast/source/weather_source.dart';
part 'hourly_weather_event.dart';
part 'hourly_weather_state.dart';

class HourlyWeatherBloc extends Bloc<HourlyWeatherEvent, HourlyWeatherState> {
  final WeatherSource weatherSource;
  HourlyWeatherBloc(this.weatherSource) : super(HourlyWeatherInitial()) {
    on<OnGetHourlyWeather>((event, emit) async {
      emit(HourlyWeatherLoading());
      final result = await weatherSource.getHourlyWeather(event.city);
      result.fold(
        (error) => emit(HourlyWeatherError(error)),
        (data) => emit(HourlyWeatherLoaded(data)),
      );
    });
    on<OnInitialHourlyWeather>((event, emit) => emit(HourlyWeatherInitial()));
  }
}
