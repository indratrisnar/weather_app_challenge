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
      String cityName = event.cityName;
      bool hasImage = event.hasImage;
      emit(CurrentWeatherLoading());
      final result = await weatherSource.getCurrentWeather(cityName, hasImage);
      await Future.delayed(const Duration(milliseconds: 500));

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
