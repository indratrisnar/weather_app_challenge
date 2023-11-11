import 'dart:io';

import 'package:d_view/d_view.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:weather_forecast/api/urls.dart';
import 'package:weather_forecast/commons/app_route.dart';
import 'package:weather_forecast/core/helpers/dir.dart';
import 'package:weather_forecast/data/models/city.dart';
import 'package:weather_forecast/data/models/weather.dart';
import 'package:weather_forecast/presentation/bloc/current_weather/current_weather_bloc.dart';
import 'package:weather_forecast/presentation/bloc/hourly_weather/hourly_weather_bloc.dart';
import 'package:weather_forecast/presentation/controllers/city_controller.dart';
import 'package:weather_forecast/presentation/controllers/current_weather_controller.dart';
import 'package:weather_forecast/presentation/widgets/bottom_up_shadow.dart';
import 'package:weather_forecast/presentation/widgets/current_weather/current_weather_header.dart';
import 'package:weather_forecast/presentation/widgets/current_weather/current_weather_shimmer.dart';
import 'package:weather_forecast/presentation/widgets/current_weather/hourly_weather_shimmer.dart';
import 'package:weather_forecast/presentation/widgets/current_weather/item_hourly.dart';
import 'package:weather_forecast/presentation/widgets/error_refresh_widget.dart';

import '../widgets/current_weather/item_recap.dart';

class CurrentWeatherPage extends StatefulWidget {
  const CurrentWeatherPage({super.key});

  @override
  State<CurrentWeatherPage> createState() => _CurrentWeatherStatePage();
}

class _CurrentWeatherStatePage extends State<CurrentWeatherPage>
    with TickerProviderStateMixin {
  CityController cityController = Get.find<CityController>();
  CurrentWeatherController thisController = CurrentWeatherController();
  ScrollController scrollHourly = ScrollController();
  ValueNotifier<int> leftIndexHourly = ValueNotifier(0);
  String backgroundPath = '';

  refresh() {
    City currentCity = cityController.currentCity;
    if (currentCity.name == null) return;
    context
        .read<CurrentWeatherBloc>()
        .add(OnGetCurrentWeather(currentCity.name!, currentCity.hasImage));
    context
        .read<HourlyWeatherBloc>()
        .add(OnGetHourlyWeather(currentCity.name!));
    thisController.reset();
  }

  detectDateGroup() {
    double itemWidth = 60;
    double space = 8;
    scrollHourly.addListener(() {
      double currentLeftPosition = scrollHourly.position.pixels;
      double spaceLength = (currentLeftPosition ~/ itemWidth) * space;
      int index = ((currentLeftPosition - spaceLength) / itemWidth).floor();
      if (index != leftIndexHourly.value) {
        leftIndexHourly.value = index;
      }
    });
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getApplicationDocumentsDirectory().then((dir) {
        backgroundPath = dir.path;
      });
      thisController.init(vsync: this);
      detectDateGroup();
      refresh();
    });
    super.initState();
  }

  @override
  void dispose() {
    thisController.dispose();
    scrollHourly.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        forceMaterialTransparency: true,
        backgroundColor: Colors.transparent,
        title: CurrentWeatherHeader(
          menuOnPressed: () {
            Navigator.pushNamed(context, AppRoute.locations).then((value) {
              if (value != null && value == 'refresh') refresh();
            });
          },
        ),
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Obx(() {
              if (cityController.currentCity.hasImage) {
                return ExtendedImage.file(
                  File(
                    Dir.backgroundImagePath(cityController.currentCity.name!),
                  ),
                  fit: BoxFit.cover,
                );
              }
              return ExtendedImage.asset(
                'assets/bg_default.jpg',
                fit: BoxFit.cover,
              );
            }),
          ),
          Container(color: Colors.black.withOpacity(0.4)),
          Positioned(
            height: MediaQuery.of(context).size.height / 2,
            bottom: 0,
            left: 0,
            right: 0,
            child: const BottomUpShadow(),
          ),
          Positioned.fill(
            child: RefreshIndicator.adaptive(
              onRefresh: () async => refresh(),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minHeight: constraints.maxHeight,
                      ),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: DView.defaultSpace,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            DView.height(kToolbarHeight * 2),
                            currentWeatherView(),
                            DView.height(30),
                            Padding(
                              padding:
                                  EdgeInsets.only(bottom: DView.defaultSpace),
                              child: hourlyForecastView(),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget currentWeatherView() {
    return BlocConsumer<CurrentWeatherBloc, CurrentWeatherState>(
      listener: (context, state) {
        if (state is CurrentWeatherLoaded) {
          thisController.execute();
        }
      },
      builder: (context, state) {
        if (state is CurrentWeatherLoading) {
          return const CurrentWeatherShimmer();
        }
        if (state is CurrentWeatherError) {
          // return DView.error(data: state.message);
          return ErrorRefreshWidget(
            message: state.message,
            onRefresh: () => refresh(),
          );
        }
        if (state is CurrentWeatherLoaded) {
          Weather weather = state.weather;
          final now = DateTime.now();
          String dateMonth = DateFormat('MMMM d').format(now);
          String currentTime = DateFormat('d/M/yyyy hh:mm a').format(now);
          return Column(
            children: [
              SlideTransition(
                position: thisController.dateMonthOffset,
                child: FadeTransition(
                  opacity: thisController.dateMonthAnimation,
                  child: Text(
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
                ),
              ),
              SlideTransition(
                position: thisController.updatedOffset,
                child: FadeTransition(
                  opacity: thisController.updatedAnimation,
                  child: Text(
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
                ),
              ),
              SlideTransition(
                position: thisController.iconOffset,
                child: FadeTransition(
                  opacity: thisController.iconAnimation,
                  child: ExtendedImage.network(
                    URLs.weatherIcon(weather.icon),
                    height: 150,
                  ),
                ),
              ),
              SlideTransition(
                position: thisController.mainOffset,
                child: FadeTransition(
                  opacity: thisController.mainAnimation,
                  child: Text(
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
                ),
              ),
              SlideTransition(
                position: thisController.descriptionOffset,
                child: FadeTransition(
                  opacity: thisController.descriptionAnimation,
                  child: Text(
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
                ),
              ),
              DView.height(10),
              SlideTransition(
                position: thisController.temperatureOffset,
                child: FadeTransition(
                  opacity: thisController.temperatureAnimation,
                  child: Row(
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
                ),
              ),
              DView.height(20),
              GridView.count(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                crossAxisCount: 4,
                crossAxisSpacing: 8,
                padding: const EdgeInsets.all(0),
                children: [
                  SlideTransition(
                    position: thisController.humidityOffset,
                    child: FadeTransition(
                      opacity: thisController.humidityAnimation,
                      child: ItemRecap(
                        Icons.water_drop_outlined,
                        'Humidity',
                        '${weather.humidity}%',
                      ),
                    ),
                  ),
                  SlideTransition(
                    position: thisController.pressureOffset,
                    child: FadeTransition(
                      opacity: thisController.pressureAnimation,
                      child: ItemRecap(
                        Icons.compare_arrows_rounded,
                        'Pressure',
                        '${weather.pressure}hPa',
                      ),
                    ),
                  ),
                  SlideTransition(
                    position: thisController.windOffset,
                    child: FadeTransition(
                      opacity: thisController.windAnimation,
                      child: ItemRecap(
                        Icons.air,
                        'Wind',
                        '${(weather.wind * 3.6).toStringAsFixed(2)}km/h',
                      ),
                    ),
                  ),
                  SlideTransition(
                    position: thisController.feelsLikeOffset,
                    child: FadeTransition(
                      opacity: thisController.feelsLikeAnimation,
                      child: ItemRecap(
                        Icons.thermostat,
                        'Feels Like',
                        '${(weather.feelsLike - 273.15).round()}\u2103',
                      ),
                    ),
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
    final decoration = BoxDecoration(
      color: Colors.blueGrey.withOpacity(0.5),
      borderRadius: BorderRadius.circular(20),
    );
    return SizedBox(
      height: 180,
      child: BlocBuilder<HourlyWeatherBloc, HourlyWeatherState>(
        builder: (context, state) {
          if (state is HourlyWeatherLoading) {
            return Container(
              decoration: decoration,
              child: const HourlyWeatherShimmer(),
            );
          }
          if (state is HourlyWeatherError) {
            return Container(
              decoration: decoration,
              child: DView.error(data: state.message),
            );
          }
          if (state is HourlyWeatherLoaded) {
            List<Weather> weathers = state.weathers;
            return SlideTransition(
              position: thisController.hourlyOffset,
              child: FadeTransition(
                opacity: thisController.hourlyAnimation,
                child: Container(
                  height: 200,
                  decoration: decoration,
                  child: Stack(
                    children: [
                      ListView.builder(
                        controller: scrollHourly,
                        scrollDirection: Axis.horizontal,
                        physics: const BouncingScrollPhysics(),
                        itemCount: weathers.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: EdgeInsets.only(
                              left: index == 0 ? 70 : 5,
                              right: index == weathers.length - 1 ? 10 : 5,
                            ),
                            child: ItemHourly(weather: weathers[index]),
                          );
                        },
                      ),
                      ValueListenableBuilder<int>(
                          valueListenable: leftIndexHourly,
                          builder: (_, i, ___) {
                            int lastIndex = weathers.length;
                            int index = i <= 0
                                ? 1
                                : i > lastIndex
                                    ? lastIndex
                                    : i;
                            Weather weather = weathers[index];
                            String day =
                                DateFormat('EEE').format(weather.dateTime);
                            String date =
                                DateFormat('d').format(weather.dateTime);
                            return Container(
                              decoration: BoxDecoration(
                                color: Colors.blueGrey,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              margin: const EdgeInsets.all(10),
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
                            );
                          }),
                    ],
                  ),
                ),
              ),
            );
          }
          return Container();
        },
      ),
    );
  }
}
