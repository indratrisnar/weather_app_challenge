import 'package:d_method/d_method.dart';
import 'package:get/get.dart';
import 'package:weather_forecast/data/models/city.dart';
import 'package:weather_forecast/data/source/city_source.dart';

class CityController extends GetxController {
  CityController(this.citySource);
  final CitySource citySource;

  final Rx<City> _currentCity = const City().obs;
  City get currentCity => _currentCity.value;

  @override
  void onInit() {
    City? city = citySource.getCurrentCity();
    if (city != null) _currentCity.value = city;

    DMethod.log('onInit() - $runtimeType');
    DMethod.log('Current: ${currentCity.toJson()}');

    DMethod.log('Cities:');
    final list = citySource.getCities();
    list?.forEach((element) {
      DMethod.log(element.toJson().toString());
    });

    super.onInit();
  }

  Future<void> setCurrentCity(City city) async {
    // current city updated locally
    bool saved = await citySource.setCurrentCity(city);
    if (saved) _currentCity.value = city;

    // DMethod.log('setCurrentCity() - $runtimeType');
    // DMethod.log('Current: ${currentCity.toJson()}');
  }
}
