import 'package:d_method/d_method.dart';
import 'package:get/get.dart';
import 'package:weather_forecast/data/source/city_source.dart';

class CityController extends GetxController {
  CityController(this.citySource);
  final CitySource citySource;

  @override
  void onInit() {
    String? city = citySource.getCurrentCity();
    _currentCity.value = city ?? '';

    List<String>? list = citySource.getCities();
    _cities.assignAll(list ?? []);

    DMethod.printBasic('onInit() - $runtimeType');
    DMethod.printBasic('Current: $currentCity');
    DMethod.printBasic('Cities: $cities');
    super.onInit();
  }

  final _currentCity = ''.obs;
  String get currentCity => _currentCity.value;

  final _cities = <String>[].obs;
  List<String> get cities => _cities;

  setCurrentCity(String n) async {
    bool saved = await citySource.cacheCurrentCity(n);
    if (saved) _currentCity.value = n;

    DMethod.printBasic('setCurrentCity() - $runtimeType');
    DMethod.printBasic('Current: $currentCity');
    DMethod.printBasic('Cities: $cities');
  }

  addNewCity(String n) async {
    if (cities.isEmpty) {
      setCurrentCity(n);
    }

    List<String> nCities = [...cities, n];
    nCities.sort();

    // cities updated
    bool saved = await citySource.cacheCities(nCities);
    if (saved) _cities.assignAll(nCities);

    DMethod.printBasic('addNewCity() - $runtimeType');
    DMethod.printBasic('Current: $currentCity');
    DMethod.printBasic('Cities: $cities');
  }

  Future<bool> removeCity(String n) async {
    List<String> nCities =
        cities.where((e) => e.toLowerCase() != n.toLowerCase()).toList();

    bool saved = await citySource.cacheCities(nCities);
    if (saved) {
      _cities.remove(n);
      if (n == currentCity) {
        await setCurrentCity(cities.isEmpty ? '' : cities.first);
      }
      DMethod.printBasic('removeCity(true) - $runtimeType');
      DMethod.printBasic('Current: $currentCity');
      DMethod.printBasic('Cities: $cities');
      return true;
    }

    DMethod.printBasic('removeCity(false) - $runtimeType');
    DMethod.printBasic('Current: $currentCity');
    DMethod.printBasic('Cities: $cities');
    return false;
  }
}
