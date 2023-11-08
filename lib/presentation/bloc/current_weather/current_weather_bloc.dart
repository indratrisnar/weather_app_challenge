import 'package:weather_forecast/data/models/weather.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_forecast/data/source/weather_source.dart';
part 'current_weather_event.dart';
part 'current_weather_state.dart';

class CurrentWeatherBloc
    extends Bloc<CurrentWeatherEvent, CurrentWeatherState> {
  final WeatherSource weatherSource;
  CurrentWeatherBloc(this.weatherSource) : super(CurrentWeatherInitial()) {
    on<OnGetCurrentWeather>((event, emit) async {
      emit(CurrentWeatherLoading());
      final result = await weatherSource.getCurrentWeather(event.city);
      await Future.delayed(const Duration(seconds: 2));
      result.fold(
        (error) => emit(CurrentWeatherError(error)),
        (data) => emit(CurrentWeatherLoaded(data)),
      );
    });
    on<OnInitialCurrentWeather>((event, emit) {
      emit(CurrentWeatherInitial());
    });
  }
}
