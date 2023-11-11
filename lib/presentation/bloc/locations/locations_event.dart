part of 'locations_bloc.dart';

sealed class LocationsEvent {}

class OnGetLocations extends LocationsEvent {}

class OnInitialLocations extends LocationsEvent {}

class OnRemoveLocation extends LocationsEvent {
  final Weather weather;

  OnRemoveLocation(this.weather);
}

class OnAddLocation extends LocationsEvent {
  final String cityName;
  final File? file;

  OnAddLocation({required this.cityName, this.file});
}

class OnSearchLocation extends LocationsEvent {
  final String query;

  OnSearchLocation(this.query);
}
