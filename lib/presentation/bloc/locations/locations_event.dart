part of 'locations_bloc.dart';

sealed class LocationsEvent {}

class OnGetLocations extends LocationsEvent {
  final List<String> cities;

  OnGetLocations(this.cities);
}

class OnRemoveCity extends LocationsEvent {
  final String city;

  OnRemoveCity(this.city);
}

class OnInitialLocations extends LocationsEvent {}

class OnSearchLocation extends LocationsEvent {
  final String query;

  OnSearchLocation(this.query);
}
