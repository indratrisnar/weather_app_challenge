import 'package:d_view/d_view.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:intl/intl.dart';
import 'package:weather_forecast/api/urls.dart';
import 'package:weather_forecast/commons/app_route.dart';
import 'package:weather_forecast/data/models/weather.dart';
import 'package:weather_forecast/presentation/bloc/current_weather/current_weather_bloc.dart';
import 'package:weather_forecast/presentation/bloc/hourly_weather/hourly_weather_bloc.dart';
import 'package:weather_forecast/presentation/controllers/city_controller.dart';
import 'package:weather_forecast/presentation/widgets/bottom_up_shadow.dart';
import 'package:weather_forecast/presentation/widgets/current_weather_shimmer.dart';
import 'package:weather_forecast/presentation/widgets/hourly_weather_shimmer.dart';
import 'package:weather_forecast/presentation/widgets/item_hourly.dart';

import '../widgets/item_recap.dart';

class CurrentWeatherPage extends StatefulWidget {
  const CurrentWeatherPage({super.key});

  @override
  State<CurrentWeatherPage> createState() => _CurrentWeatherStatePage();
}

class _CurrentWeatherStatePage extends State<CurrentWeatherPage> {
  CityController cityController = Get.find<CityController>();

  refresh() {
    String currentCity = cityController.currentCity;
    if (currentCity == '') return;
    context.read<CurrentWeatherBloc>().add(OnGetCurrentWeather(currentCity));
    context.read<HourlyWeatherBloc>().add(OnGetHourlyWeather(currentCity));
  }

  @override
  void initState() {
    refresh();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: appBar(),
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: ExtendedImage.asset(
              'assets/bg_default.jpg',
              fit: BoxFit.cover,
            ),
          ),
          Container(color: Colors.black.withOpacity(0.4)),
          Positioned(
            height: MediaQuery.of(context).size.height / 3,
            bottom: 0,
            left: 0,
            right: 0,
            child: const BottomUpShadow(),
          ),
          Positioned.fill(
            child: RefreshIndicator.adaptive(
              onRefresh: () async => refresh(),
              child: ListView(
                padding: EdgeInsets.symmetric(
                  horizontal: DView.defaultSpace,
                ),
                physics: const BouncingScrollPhysics(),
                children: [
                  DView.height(kToolbarHeight * 2),
                  currentWeatherView(),
                  DView.height(30),
                  hourlyForecastView(),
                  DView.height(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget currentWeatherView() {
    return BlocBuilder<CurrentWeatherBloc, CurrentWeatherState>(
      builder: (context, state) {
        if (state is CurrentWeatherLoading) {
          return const CurrentWeatherShimmer();
        }
        if (state is CurrentWeatherError) {
          return DView.error(data: state.message);
        }
        if (state is CurrentWeatherLoaded) {
          Weather weather = state.weather;
          final now = DateTime.now();
          String dateMonth = DateFormat('MMMM d').format(now);
          String currentTime = DateFormat('d/M/yyyy hh:mm a').format(now);
          return Column(
            children: [
              Text(
                dateMonth,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 26,
                  shadows: [
                    Shadow(
                      color: Colors.black38,
                      blurRadius: 6,
                    ),
                  ],
                ),
              ),
              Text(
                'Updated as of $currentTime',
                style: const TextStyle(
                  color: Colors.white60,
                  fontSize: 14,
                  shadows: [
                    Shadow(
                      color: Colors.black38,
                      blurRadius: 6,
                    ),
                  ],
                ),
              ),
              ExtendedImage.network(
                URLs.weatherIcon(weather.icon),
                height: 150,
              ),
              Text(
                weather.main,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  shadows: [
                    Shadow(
                      color: Colors.black38,
                      blurRadius: 6,
                    ),
                  ],
                ),
              ),
              Text(
                '- ${weather.description} -',
                style: const TextStyle(
                  color: Colors.white60,
                  fontSize: 14,
                  shadows: [
                    Shadow(
                      color: Colors.black38,
                      blurRadius: 6,
                    ),
                  ],
                ),
              ),
              DView.height(10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${(weather.temperature - 273.15).round()}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 80,
                      fontWeight: FontWeight.bold,
                      shadows: [
                        Shadow(
                          color: Colors.black38,
                          blurRadius: 6,
                        ),
                      ],
                    ),
                  ),
                  const Text(
                    '\u2103',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 30,
                      height: 2,
                      fontWeight: FontWeight.bold,
                      shadows: [
                        Shadow(
                          color: Colors.black38,
                          blurRadius: 6,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              DView.height(20),
              GridView.count(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                crossAxisCount: 4,
                crossAxisSpacing: 8,
                padding: const EdgeInsets.all(0),
                children: [
                  ItemRecap(
                    Icons.water_drop_outlined,
                    'Humidity',
                    '${weather.humidity}%',
                  ),
                  ItemRecap(
                    Icons.compare_arrows_rounded,
                    'Pressure',
                    '${weather.pressure}hPa',
                  ),
                  ItemRecap(
                    Icons.air,
                    'Wind',
                    '${(weather.wind * 3.6).toStringAsFixed(2)}km/h',
                  ),
                  ItemRecap(
                    Icons.thermostat,
                    'Feels Like',
                    '${(weather.feelsLike - 273.15).round()}\u2103',
                  ),
                ],
              ),
            ],
          );
        }
        return Container();
      },
    );
  }

  Widget hourlyForecastView() {
    return Container(
      height: 200,
      decoration: BoxDecoration(
        color: Colors.blueGrey.withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
      ),
      child: BlocBuilder<HourlyWeatherBloc, HourlyWeatherState>(
        builder: (context, state) {
          if (state is HourlyWeatherLoading) {
            return const HourlyWeatherShimmer();
          }
          if (state is HourlyWeatherError) {
            return DView.error(data: state.message);
          }
          if (state is HourlyWeatherLoaded) {
            List<Weather> weathers = state.weathers;
            return GroupedListView<Weather, String>(
              elements: weathers,
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.all(0),
              // itemExtent: 50,
              physics: const BouncingScrollPhysics(),
              groupBy: (e) => DateFormat('yyyy-MM-dd').format(e.dateTime),
              groupHeaderBuilder: (e) {
                String day = DateFormat('EEE').format(e.dateTime);
                String date = DateFormat('d').format(e.dateTime);
                return Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.blueGrey,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    margin: const EdgeInsets.all(16),
                    width: 50,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          day,
                          style: const TextStyle(color: Colors.white),
                        ),
                        Text(
                          date,
                          style: const TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                );
              },
              useStickyGroupSeparators: true,
              floatingHeader: true,
              indexedItemBuilder: (context, weather, index) {
                return Padding(
                  padding: EdgeInsets.only(
                    left: index == 0 ? 0 : 7,
                    right: index == weathers.length - 1 ? 16 : 7,
                  ),
                  child: ItemHourly(weather: weather),
                );
              },
            );
          }
          return Container();
        },
      ),
    );
  }

  Widget appBar() {
    return Row(
      children: [
        const Icon(
          Icons.location_on,
          size: 30,
          color: Colors.white,
        ),
        DView.width(4),
        Obx(
          () {
            String cityName = cityController.currentCity;
            return Hero(
              tag: 'city_name_tag_$cityName',
              child: Material(
                color: Colors.transparent,
                child: Text(
                  cityName == '' ? 'City is not setup' : cityName,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    shadows: [
                      Shadow(
                        color: Colors.black,
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
        const Spacer(),
        IconButton(
          onPressed: () {
            Navigator.pushNamed(context, AppRoute.locations).then((value) {
              if (value != null && value == 'refresh') refresh();
            });
          },
          icon: const Icon(
            Icons.menu,
            color: Colors.white,
            size: 30,
          ),
        ),
      ],
    );
  }
}
