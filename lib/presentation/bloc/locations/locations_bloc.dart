import 'dart:io';
import 'package:d_info/d_info.dart';
import 'package:dartz/dartz.dart';
import 'package:get/get.dart';
import 'package:rxdart/rxdart.dart';
import 'package:weather_forecast/core/helpers/dir.dart';
import 'package:weather_forecast/core/repository/locations_repository.dart';
import 'package:weather_forecast/data/models/weather.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_forecast/data/source/city_source.dart';
import 'package:weather_forecast/data/source/weather_source.dart';
import 'package:weather_forecast/presentation/controllers/city_controller.dart';

import '../../../data/models/city.dart';
part 'locations_event.dart';
part 'locations_state.dart';

class LocationsBloc extends Bloc<LocationsEvent, LocationsState> {
  final WeatherSource _weatherSource;
  final CitySource _citySource;
  LocationsBloc(this._weatherSource, this._citySource)
      : super(LocationsInitial()) {
    _initial();
    _getLocation();
    _addLocation();
    _removeLocation();
    _searchLocation();
  }

  void _initial() {
    return on<OnInitialLocations>((event, emit) {
      emit(LocationsInitial());
    });
  }

  void _getLocation() {
    return on<OnGetLocations>((event, emit) async {
      final stateBefore = state;
      emit(LocationsLoading());

      List<City>? cities = _citySource.getCities();
      if (cities == null) {
        // cancel loading state
        emit(stateBefore);
        return;
      }

      // request
      Either<String, List<Weather>> weathersResult =
          await _weatherSource.getLocationsWeather(cities);
      weathersResult.fold(
        (error) => emit(LocationsError(error)),
        (data) {
          // backup locations repo
          LocationRepository.savedLocations = data;

          emit(LocationsLoaded(data));
        },
      );
    });
  }

  void _addLocation() {
    return on<OnAddLocation>((event, emit) async {
      File? file = event.file;
      bool hasImage = file != null;

      // cancel if representation of city has present
      City? cityFound = _citySource.getCities()?.firstWhereOrNull(
            (e) => e.name!.toLowerCase() == event.cityName.toLowerCase(),
          );
      if (cityFound != null) {
        DInfo.toastError('City has present');
        return;
      }

      // request
      Either<String, Weather> weatherResult =
          await _weatherSource.getCurrentWeather(event.cityName, hasImage);
      if (weatherResult.isLeft()) {
        // error
        String error = (weatherResult as Left).value;
        DInfo.toastError(error);
      } else {
        // new weather
        Weather weather = (weatherResult as Right).value;

        // save image locally if file exist
        if (hasImage) {
          String newPath = Dir.backgroundImagePath(weather.city.name!);
          await file.copy(newPath);
        }

        // save to local preference
        _citySource.addCity(weather.city);

        // backup location repo
        await LocationRepository.add(weather);

        // set to state
        emit(LocationsLoaded(LocationRepository.savedLocations));
      }
    });
  }

  void _removeLocation() {
    return on<OnRemoveLocation>((event, emit) {
      Weather weather = event.weather;
      City city = weather.city;

      // update cities cache
      _citySource.removeCity(city);

      // delete file city image
      if (city.hasImage) File(Dir.backgroundImagePath(city.name!)).delete();

      CityController cityController = Get.find<CityController>();
      if (cityController.currentCity.name == city.name) {
        // update current city if deletedCity is previous currentCity
        City? firstCity = _citySource.getCities()?.firstOrNull;
        cityController.setCurrentCity(firstCity ?? const City());
      }

      // backup repo
      LocationRepository.remove(weather);

      emit(LocationsLoaded(LocationRepository.savedLocations));
    });
  }

  void _searchLocation() {
    return on<OnSearchLocation>(
      (event, emit) {
        List<Weather> weathers = LocationRepository.savedLocations.where((e) {
          String cityElement = e.city.name?.toLowerCase() ?? '';
          String query = event.query.toLowerCase();
          return cityElement.contains(query);
        }).toList();
        emit(LocationsLoaded(weathers));
      },
      transformer: (events, mapper) {
        // to wait realtime onChange input
        return events
            .debounceTime(const Duration(milliseconds: 500))
            .flatMap(mapper);
      },
    );
  }
}
