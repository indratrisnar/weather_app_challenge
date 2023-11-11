import 'package:d_method/d_method.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_forecast/data/models/weather.dart';
import 'package:weather_forecast/presentation/bloc/locations/locations_bloc.dart';

class AppBlocObserver extends BlocObserver {
  const AppBlocObserver();

  @override
  void onTransition(
    Bloc<dynamic, dynamic> bloc,
    Transition<dynamic, dynamic> transition,
  ) {
    super.onTransition(bloc, transition);
    // if (bloc is LocationsBloc) locationsBloc(bloc, transition);
  }

  locationsBloc(
    Bloc<dynamic, dynamic> bloc,
    Transition<dynamic, dynamic> transition,
  ) {
    DMethod.log(
      '${transition.currentState.runtimeType} => event ${transition.event.runtimeType} => ${transition.nextState.runtimeType}',
    );
    if (transition.nextState is LocationsLoaded) {
      for (Weather weather in transition.nextState.weathers) {
        DMethod.log(weather.city.name.toString());
      }
    }
    DMethod.log('');
  }
}
