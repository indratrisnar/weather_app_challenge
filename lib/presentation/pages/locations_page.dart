import 'package:blur/blur.dart';
import 'package:d_input/d_input.dart';
import 'package:d_view/d_view.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/instance_manager.dart';
import 'package:weather_forecast/commons/extension.dart';
import 'package:weather_forecast/data/models/weather.dart';
import 'package:weather_forecast/presentation/bloc/current_weather/current_weather_bloc.dart';
import 'package:weather_forecast/presentation/bloc/hourly_weather/hourly_weather_bloc.dart';

import 'package:weather_forecast/presentation/bloc/locations/locations_bloc.dart';
import 'package:weather_forecast/presentation/controllers/city_controller.dart';
import 'package:d_button/d_button.dart';
import 'package:weather_forecast/presentation/controllers/locations_controller.dart';
import 'package:weather_forecast/presentation/widgets/locations/item_city.dart';
import 'package:weather_forecast/presentation/widgets/locations/locations_shimmer.dart';
import 'package:weather_forecast/presentation/widgets/top_down_shadow.dart';

class LocationsPage extends StatefulWidget {
  const LocationsPage({super.key});

  @override
  State<LocationsPage> createState() => _LocationsPageState();
}

class _LocationsPageState extends State<LocationsPage>
    with TickerProviderStateMixin {
  CityController cityController = Get.find<CityController>();
  LocationsController thisController = LocationsController();

  refresh() {
    List<String> cities = cityController.cities;
    if (cities.isEmpty) return;

    context.read<LocationsBloc>().add(OnGetLocations(cities));
    thisController.reset();
  }

  addCity(String city) async {
    cityController.addNewCity(city).then((value) {
      Navigator.pop(context);
      refresh();
    });
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
    thisController.init(vsync: this);
    refresh();

    super.initState();
  }

  @override
  void dispose() {
    thisController.dispose();
    super.dispose();
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
              header(),
              Expanded(child: citiesView()),
              Padding(
                padding: EdgeInsets.all(DView.defaultSpace),
                child: addNewButton(),
              ),
            ],
          ),
          // searchBox(),
        ]),
      ),
    );
  }

  Widget searchBox() {
    return Center(
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
        ),
        padding: const EdgeInsets.fromLTRB(20, 4, 4, 4),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                decoration: const InputDecoration(
                  isDense: true,
                  contentPadding: EdgeInsets.all(0),
                  border: InputBorder.none,
                  hintText: 'Find city',
                  hintStyle: TextStyle(
                    color: Colors.black38,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                style: const TextStyle(
                  color: Colors.blueGrey,
                  fontWeight: FontWeight.bold,
                ),
                onChanged: (value) {
                  context.read<LocationsBloc>().add(OnSearchLocation(value));
                },
              ),
            ),
            DButtonBorder(
              height: 36,
              width: 36,
              radius: 36,
              borderWidth: 1,
              borderColor: Colors.blueGrey.shade300,
              mainColor: Colors.transparent,
              child: const Icon(Icons.clear, color: Colors.blueGrey),
              onClick: () {
                thisController.searchAnimation.animateBack(0.0);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget citiesView() {
    return BlocConsumer<LocationsBloc, LocationsState>(
      listener: (context, state) {
        if (state is LocationsError || state is LocationsLoaded) {
          thisController.btnAddAnimation.forward(from: 0.0);
        }
      },
      builder: (context, state) {
        if (state is LocationsLoading) return const LocationShimmer();
        if (state is LocationsError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 30,
                    vertical: 8,
                  ),
                  child: const Text(
                    'Cities is not present',
                    style: TextStyle(
                      color: Colors.blueGrey,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ).frosted(
                  blur: 1,
                  borderRadius: BorderRadius.circular(30),
                  frostColor: Colors.white.withOpacity(0.5),
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
                      cityController
                          .setCurrentCity(weather.cityName ?? '')
                          .then((value) {
                        Navigator.pop(context, 'refresh');
                      });
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

  Container header() {
    return Container(
      margin: EdgeInsets.fromLTRB(
        20,
        MediaQuery.of(context).padding.top,
        20,
        0,
      ),
      height: kToolbarHeight,
      child: AnimatedBuilder(
        animation: thisController.searchAnimation,
        builder: (context, child) {
          if (thisController.searchAnimation.value == 1) {
            return searchBox();
          }
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Saved Locations',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                ),
              ),
              IconButton(
                onPressed: () {
                  thisController.searchAnimation.forward(from: 0.0);
                },
                icon: Transform.flip(
                  flipX: true,
                  child: const Icon(Icons.search),
                ),
                color: Colors.white,
              ),
            ],
          );
        },
      ),
    );
  }

  Widget addNewButton() {
    return SlideTransition(
      position: thisController.btnAddOffset,
      child: FadeTransition(
        opacity: thisController.btnAddAnimation,
        child: DButtonFlat(
          // mainColor: Theme.of(context).primaryColor.withOpacity(0.8),
          mainColor: Colors.transparent,
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
        ).frosted(
          blur: 2,
          borderRadius: BorderRadius.circular(16),
          frostColor: Colors.blueGrey,
          frostOpacity: 0.5,
        ),
      ),
    );
  }

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
}
