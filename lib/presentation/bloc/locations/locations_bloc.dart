import 'package:weather_forecast/core/repository/locations_repository.dart';
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
        (data) {
          LocationRepository.savedLocations = data;
          emit(LocationsLoaded(data));
        },
      );
    });
    on<OnRemoveCity>((event, emit) {
      LocationRepository.savedLocations.removeWhere(
        (e) => e.cityName?.toLowerCase() != event.city.toLowerCase(),
      );

      emit(LocationsLoaded(LocationRepository.savedLocations));
    });
    on<OnInitialLocations>((event, emit) {
      emit(LocationsInitial());
    });
    on<OnSearchLocation>((event, emit) {
      List<Weather> nWeathers = LocationRepository.savedLocations
          .where(
            (e) =>
                e.cityName?.toLowerCase().contains(event.query.toLowerCase()) ??
                false,
          )
          .toList();
      emit(LocationsLoaded(nWeathers));
    });
  }
}
