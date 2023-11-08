import 'package:d_input/d_input.dart';
import 'package:d_view/d_view.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/instance_manager.dart';
import 'package:weather_forecast/commons/extension.dart';
import 'package:weather_forecast/models/weather.dart';
import 'package:weather_forecast/presentation/bloc/current_weather/current_weather_bloc.dart';
import 'package:weather_forecast/presentation/bloc/hourly_weather/hourly_weather_bloc.dart';

import 'package:weather_forecast/presentation/bloc/locations/locations_bloc.dart';
import 'package:weather_forecast/presentation/controllers/city_controller.dart';
import 'package:d_button/d_button.dart';
import 'package:weather_forecast/presentation/widgets/item_city.dart';
import 'package:weather_forecast/presentation/widgets/top_down_shadow.dart';

class LocationsPage extends StatefulWidget {
  const LocationsPage({super.key});
  static const route = '/locations';

  @override
  State<LocationsPage> createState() => _LocationsPageState();
}

class _LocationsPageState extends State<LocationsPage> {
  CityController cityController = Get.find<CityController>();

  addNewCityView() {
    final edtCity = TextEditingController();
    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      builder: (context) => Padding(
        padding: EdgeInsets.fromLTRB(
          20,
          0,
          20,
          MediaQuery.of(context).viewInsets.bottom + 40,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            DInput(
              controller: edtCity,
              radius: BorderRadius.circular(16),
              hint: 'Type city name',
              autofocus: true,
            ),
            DView.height(),
            DButtonElevation(
              height: 46,
              radius: 16,
              onClick: () => addCity(edtCity.text.capitalize),
              mainColor: Theme.of(context).primaryColor,
              child: const Text(
                'Add',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  addCity(String city) {
    cityController.addNewCity(city);
    Navigator.pop(context);
    refresh();
  }

  refresh() {
    List<String> cities = cityController.cities;
    if (cities.isEmpty) return;

    context.read<LocationsBloc>().add(OnGetLocations(cities));
  }

  removeCity(String city) {
    cityController.removeCity(city).then((value) {
      if (value) {
        context.read<LocationsBloc>().add(OnRemoveCity(city));
        if (cityController.currentCity == '') {
          context.read<LocationsBloc>().add(OnInitialLocations());
          context.read<CurrentWeatherBloc>().add(OnInitialCurrentWeather());
          context.read<HourlyWeatherBloc>().add(OnInitialHourlyWeather());
        }
      }
    });
  }

  @override
  void initState() {
    // if state has no data
    if (context.read<LocationsBloc>().state is! LocationsLoaded) refresh();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        // extendBody: true,
        body: Stack(children: [
          Positioned.fill(
            bottom: 0,
            left: 0,
            right: 0,
            top: 0,
            child: ExtendedImage.asset(
              'assets/bg_default.jpg',
              fit: BoxFit.cover,
            ),
          ),
          Positioned(
            top: 0,
            height: MediaQuery.of(context).size.height / 3,
            width: MediaQuery.of(context).size.width,
            child: const TopDownShadow(),
          ),
          Column(
            children: [
              appBar(),
              Expanded(child: citiesView()),
              Padding(
                padding: EdgeInsets.all(DView.defaultSpace),
                child: addNewButton(),
              ),
            ],
          ),
        ]),
      ),
    );
  }

  Widget citiesView() {
    return BlocBuilder<LocationsBloc, LocationsState>(
      builder: (context, state) {
        if (state is LocationsLoading) return DView.loadingCircle();
        if (state is LocationsError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 30,
                    vertical: 8,
                  ),
                  child: const Text(
                    'Cities is not present',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                DView.height(),
                DButtonCircle(
                  onClick: () => refresh(),
                  diameter: 40,
                  mainColor: Colors.white.withOpacity(0.3),
                  child: const Icon(
                    Icons.refresh,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          );
        }
        if (state is LocationsLoaded) {
          List<Weather> weathers = state.weathers;
          return RefreshIndicator.adaptive(
            onRefresh: () async => refresh(),
            child: ListView.builder(
              itemCount: weathers.length,
              padding: const EdgeInsets.all(0),
              physics: const BouncingScrollPhysics(),
              itemBuilder: (context, index) {
                Weather weather = weathers[index];
                return Padding(
                  padding: EdgeInsets.only(
                    top: 10,
                    bottom: index == weathers.length - 1 ? 20 : 10,
                    left: 20,
                    right: 20,
                  ),
                  child: GestureDetector(
                    onTap: () {
                      cityController.setCurrentCity(weather.cityName ?? '');
                      Navigator.pop(context, 'refresh');
                    },
                    child: Dismissible(
                      key: Key('${weather.id}'),
                      direction: DismissDirection.endToStart,
                      dismissThresholds: const {
                        DismissDirection.endToStart: 0.5,
                      },
                      background: Align(
                        alignment: Alignment.centerRight,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          height: 50,
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.only(right: 20),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.keyboard_double_arrow_left_rounded,
                              ),
                              DView.width(8),
                              const Text(
                                'Remove',
                                style: TextStyle(
                                  color: Colors.red,
                                  fontSize: 18,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      onDismissed: (direction) =>
                          removeCity(weather.cityName ?? ""),
                      child: ItemCity(weather: weather),
                    ),
                  ),
                );
              },
            ),
          );
        }
        return Container();
      },
    );
  }

  Padding appBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        title: const Text('Saved Locations'),
        titleTextStyle: const TextStyle(fontSize: 18),
        forceMaterialTransparency: true,
        actions: [
          IconButton(
            onPressed: () {},
            icon: Transform.flip(
              flipX: true,
              child: const Icon(Icons.search),
            ),
          ),
        ],
      ),
    );
  }

  DButtonFlat addNewButton() {
    return DButtonFlat(
      mainColor: Theme.of(context).primaryColor.withOpacity(0.8),
      height: 46,
      onClick: () => addNewCityView(),
      radius: 16,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.add_circle_outlined,
            color: Colors.white,
          ),
          DView.width(8),
          const Text(
            'Add New City',
            style: TextStyle(
              fontSize: 16,
              color: Colors.white,
              height: 1,
            ),
          ),
        ],
      ),
    );
  }
}
