part of 'locations_bloc.dart';

sealed class LocationsState {}

final class LocationsInitial extends LocationsState {}

final class LocationsLoading extends LocationsState {}

final class LocationsError extends LocationsState {
  final String message;

  LocationsError(this.message);
}

final class LocationsLoaded extends LocationsState {
  final List<Weather> weathers;

  LocationsLoaded(this.weathers);
}
