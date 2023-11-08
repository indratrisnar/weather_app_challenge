import 'package:d_view/d_view.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:weather_forecast/api/urls.dart';
import 'package:weather_forecast/models/weather.dart';
import 'package:weather_forecast/presentation/bloc/current_weather/current_weather_bloc.dart';
import 'package:weather_forecast/presentation/bloc/hourly_weather/hourly_weather_bloc.dart';
import 'package:weather_forecast/presentation/controllers/city_controller.dart';
import 'package:weather_forecast/presentation/pages/locations_page.dart';
import 'package:weather_forecast/presentation/widgets/bottom_up_shadow.dart';

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
          Column(
            children: [
              DView.height(40),
              header(),
              Expanded(
                child: BlocBuilder<CurrentWeatherBloc, CurrentWeatherState>(
                  builder: (context, state) {
                    if (state is CurrentWeatherLoading) {
                      return DView.loadingCircle();
                    }
                    if (state is CurrentWeatherError) {
                      return DView.error(data: state.message);
                    }
                    if (state is CurrentWeatherLoaded) {
                      Weather weather = state.weather;
                      return RefreshIndicator.adaptive(
                        onRefresh: () async => refresh(),
                        child: ListView(
                          padding: EdgeInsets.symmetric(
                              horizontal: DView.defaultSpace),
                          physics: const BouncingScrollPhysics(),
                          children: [
                            mainInfo(weather),
                            DView.height(30),
                            additionalInfo(weather),
                            DView.height(40),
                            hourlyForecastBox(),
                            DView.height(),
                          ],
                        ),
                      );
                    }
                    return Container();
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Container hourlyForecastBox() {
    return Container(
      height: 200,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Stack(
        children: [
          Positioned.fill(child: hourlyForecastView()),
          const Align(
            alignment: Alignment.centerLeft,
            child: Icon(
              Icons.keyboard_double_arrow_left,
              color: Colors.white,
            ),
          ),
          const Align(
            alignment: Alignment.centerRight,
            child: Icon(
              Icons.keyboard_double_arrow_right,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget hourlyForecastView() {
    return BlocBuilder<HourlyWeatherBloc, HourlyWeatherState>(
      builder: (context, state) {
        if (state is HourlyWeatherLoading) {
          return DView.loadingCircle();
        }
        if (state is HourlyWeatherError) {
          return DView.error(data: state.message);
        }
        if (state is HourlyWeatherLoaded) {
          List<Weather> weathers = state.weathers;
          return ListView.builder(
            itemCount: weathers.length,
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            itemBuilder: (context, index) {
              Weather weather = weathers[index];
              String date = DateFormat('EEE d').format(weather.dateTime);
              String time = DateFormat('hh:mm a').format(weather.dateTime);
              return Padding(
                padding: EdgeInsets.only(
                  left: index == 0 ? 16 : 7,
                  right: index == weathers.length - 1 ? 16 : 7,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      date,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      time,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 12,
                      ),
                    ),
                    ExtendedImage.network(
                      URLs.weatherIcon(weather.icon),
                      height: 70,
                    ),
                    Transform.translate(
                      offset: const Offset(0, -10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${(weather.temperature - 273.15).round()}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 20,
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
                            '°',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
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
                    Text(
                      '${(weather.wind * 3.6).toStringAsFixed(2)}\nkm/h',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        }
        return Container();
      },
    );
  }

  GridView additionalInfo(Weather weather) {
    return GridView.count(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      crossAxisCount: 4,
      crossAxisSpacing: 8,
      children: [
        itemAdditionalInfo(
          Icons.water_drop_outlined,
          'Humidity',
          '${weather.humidity}%',
        ),
        itemAdditionalInfo(
          Icons.compare_arrows_rounded,
          'Pressure',
          '${weather.pressure}hPa',
        ),
        itemAdditionalInfo(
          Icons.air,
          'Wind',
          '${(weather.wind * 3.6).toStringAsFixed(2)}%',
        ),
        itemAdditionalInfo(
          Icons.thermostat,
          'Feels Like',
          '${(weather.feelsLike - 273.15).round()}\u2103',
        ),
      ],
    );
  }

  Widget itemAdditionalInfo(
    IconData icon,
    String title,
    String data,
  ) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Icon(
          icon,
          size: 30,
          color: Colors.white,
        ),
        DView.height(8),
        Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
            shadows: [
              Shadow(
                color: Colors.black38,
                blurRadius: 6,
              ),
            ],
          ),
        ),
        DView.height(4),
        Text(
          data,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 14,
            shadows: [
              Shadow(
                color: Colors.black38,
                blurRadius: 6,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Column mainInfo(Weather weather) {
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
        DView.height(),
        ExtendedImage.network(
          URLs.weatherIcon(weather.icon),
          height: 150,
        ),
        Text(
          weather.main,
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
        DView.height(30),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${(weather.temperature - 273.15).round()}',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 70,
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
      ],
    );
  }

  Padding header() {
    return Padding(
      padding: const EdgeInsets.only(left: 14, right: 10),
      child: Row(
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
              return Text(
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
              );
            },
          ),
          const Spacer(),
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, LocationsPage.route).then((value) {
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
      ),
    );
  }
}
