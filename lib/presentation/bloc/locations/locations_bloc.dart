import 'package:weather_forecast/data/models/weather.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_forecast/data/source/weather_source.dart';
part 'locations_event.dart';
part 'locations_state.dart';

class LocationsBloc extends Bloc<LocationsEvent, LocationsState> {
  final WeatherSource weatherSource;
  LocationsBloc(this.weatherSource) : super(LocationsInitial()) {
    on<OnGetLocations>((event, emit) async {
      emit(LocationsLoading());
      final result = await weatherSource.getLocationsWeather(event.cities);
      await Future.delayed(const Duration(milliseconds: 300));
      result.fold(
        (error) => emit(LocationsError(error)),
        (data) => emit(LocationsLoaded(data)),
      );
    });
    on<OnRemoveCity>((event, emit) {
      List<Weather> nWeathers = (state as LocationsLoaded)
          .weathers
          .where((e) => e.cityName?.toLowerCase() != event.city.toLowerCase())
          .toList();
      emit(LocationsLoaded(nWeathers));
    });
    on<OnInitialLocations>((event, emit) {
      emit(LocationsInitial());
    });
    // on<OnSearchLocation>((event, emit) {
    //   List<Weather> nWeathers = (state as LocationsLoaded)
    //       .weathers
    //       .where((e) => e.cityName?.toLowerCase() != event.city.toLowerCase())
    //       .toList();
    //   emit(LocationsLoaded(nWeathers));
    // });
  }
}
