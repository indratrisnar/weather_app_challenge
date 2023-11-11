import 'dart:io';

import 'package:d_view/d_view.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:weather_forecast/data/models/weather.dart';

import 'package:weather_forecast/presentation/bloc/locations/locations_bloc.dart';
import 'package:weather_forecast/presentation/controllers/city_controller.dart';
import 'package:weather_forecast/presentation/controllers/locations_controller.dart';
import 'package:weather_forecast/presentation/widgets/error_refresh_widget.dart';
import 'package:weather_forecast/presentation/widgets/locations/add_new_city_button.dart';
import 'package:weather_forecast/presentation/widgets/locations/item_location.dart';
import 'package:weather_forecast/presentation/widgets/locations/locations_shimmer.dart';
import 'package:weather_forecast/presentation/widgets/locations/search_box.dart';
import 'package:weather_forecast/presentation/widgets/top_down_shadow.dart';

import '../bloc/current_weather/current_weather_bloc.dart';
import '../bloc/hourly_weather/hourly_weather_bloc.dart';

class LocationsPage extends StatefulWidget {
  const LocationsPage({super.key});

  @override
  State<LocationsPage> createState() => _LocationsPageState();
}

class _LocationsPageState extends State<LocationsPage>
    with TickerProviderStateMixin {
  CityController cityController = Get.find<CityController>();
  LocationsController thisController = LocationsController();
  FocusNode searchFocus = FocusNode();

  refresh() {
    context.read<LocationsBloc>().add(OnGetLocations());
  }

  addCity(String cityName, String imagePath) async {
    File? file = imagePath == '' ? null : File(imagePath);
    context
        .read<LocationsBloc>()
        .add(OnAddLocation(cityName: cityName, file: file));
    Navigator.pop(context);
  }

  removeCity(Weather weather) {
    context.read<LocationsBloc>().add(OnRemoveLocation(weather));
    if (cityController.currentCity.name == null) {
      // reset all bloc
      context.read<LocationsBloc>().add(OnInitialLocations());
      context.read<CurrentWeatherBloc>().add(OnInitialCurrentWeather());
      context.read<HourlyWeatherBloc>().add(OnInitialHourlyWeather());
    }
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
    searchFocus.dispose();
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
                child: SlideTransition(
                  position: thisController.btnAddOffset,
                  child: FadeTransition(
                    opacity: thisController.btnAddAnimation,
                    child: AddNewCityButton(
                      onAdd: (cityName, imagePath) {
                        addCity(cityName, imagePath);
                      },
                    ),
                  ),
                ),
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
        if (state is LocationsLoading) return const LocationShimmer();
        if (state is LocationsError) {
          return ErrorRefreshWidget(
            message: state.message,
            onRefresh: () => refresh(),
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
                  child: ItemLocation(
                    weather: weather,
                    onDismissed: (direction) => removeCity(weather),
                    onTap: () {
                      cityController.setCurrentCity(weather.city).then((value) {
                        Navigator.pop(context, 'refresh');
                      });
                    },
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
        builder: (context, _) {
          return IndexedStack(
            alignment: Alignment.bottomCenter,
            index: thisController.searchAnimation.value > 0 ? 0 : 1,
            children: [
              SlideTransition(
                position: thisController.searchOffset,
                child: FadeTransition(
                  opacity: thisController.searchAnimation,
                  child: SearchBox(
                    searchFocus: searchFocus,
                    onChanged: (query) {
                      context
                          .read<LocationsBloc>()
                          .add(OnSearchLocation(query));
                    },
                    onClose: () {
                      context.read<LocationsBloc>().add(OnSearchLocation(''));
                      searchFocus.unfocus();
                      thisController.closeSearchBox();
                    },
                  ),
                ),
              ),
              SlideTransition(
                position: thisController.headerOffset,
                child: FadeTransition(
                  opacity: thisController.headerAnimation,
                  child: Row(
                    children: [
                      const Text(
                        'Saved Locations',
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                        ),
                      ),
                      const Spacer(),
                      BlocBuilder<LocationsBloc, LocationsState>(
                        builder: (context, state) {
                          if (state is LocationsLoaded) {
                            if (state.weathers.length < 4) {
                              return IconButton(
                                tooltip: 'Refresh if list < 4',
                                onPressed: () => refresh(),
                                icon: Transform.flip(
                                  flipX: true,
                                  child: const Icon(Icons.refresh),
                                ),
                                color: Colors.white,
                              );
                            }
                          }
                          return DView.nothing();
                        },
                      ),
                      IconButton(
                        onPressed: () {
                          thisController.openSearchBox();
                          searchFocus.requestFocus();
                        },
                        icon: Transform.flip(
                          flipX: true,
                          child: const Icon(Icons.search),
                        ),
                        color: Colors.white,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
