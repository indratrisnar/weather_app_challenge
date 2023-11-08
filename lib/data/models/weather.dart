class Weather {
  final int id;
  final String main;
  final String description;
  final String icon;
  final num temperature;
  final num feelsLike;
  final num pressure;
  final num humidity;
  final num wind;
  final DateTime dateTime;
  final String? cityName;

  const Weather({
    required this.id,
    required this.main,
    required this.description,
    required this.icon,
    required this.temperature,
    required this.feelsLike,
    required this.pressure,
    required this.humidity,
    required this.wind,
    required this.dateTime,
    this.cityName,
  });

  factory Weather.fromJson(Map<String, dynamic> json) {
    return Weather(
      id: json['weather'][0]['id'],
      main: json['weather'][0]['main'],
      description: json['weather'][0]['description'],
      icon: json['weather'][0]['icon'],
      temperature: json['main']['temp'],
      feelsLike: json['main']['feels_like'],
      pressure: json['main']['pressure'],
      humidity: json['main']['humidity'],
      wind: json['wind']['speed'],
      dateTime: DateTime.fromMillisecondsSinceEpoch(json['dt'] * 1000),
      cityName: json['name'],
    );
  }

  Map<String, dynamic> toJson() => {
        "weather": [
          {
            "id": id,
            "main": main,
            "description": description,
            "icon": icon,
          }
        ],
        "main": {
          "temp": temperature,
          "feels_like": feelsLike,
          "pressure": pressure,
          "humidity": humidity,
        },
        "wind": {
          "speed": wind,
        },
        "dt": dateTime.millisecondsSinceEpoch / 1000,
        "name": cityName,
      };
}
