import 'dart:convert';

HourlyForecast hourlyForecastFromJson(String str) => HourlyForecast.fromJson(json.decode(str));

String hourlyForecastToJson(HourlyForecast data) => json.encode(data.toJson());

class HourlyForecast {
  HourlyForecast({
    required this.dt,
    required this.temp,
    required this.feels_like,
    required this.pressure,
    required this.humidity,
    required this.dewPoint,
    required this.clouds,
    required this.uvi,
    required this.visibility,
    required this.windSpeed,
    required this.windDeg,
    required this.pop,
    required this.weatherId,
    required this.weatherMain,
    required this.weatherDescription,
    required this.weatherIcon,
  });

  String dt;
  double temp;
  double feels_like;
  int pressure;
  int humidity;
  double dewPoint;
  int clouds;
  double uvi;
  int visibility;
  double windSpeed;
  int windDeg;
  double pop;
  int weatherId;
  String weatherMain;
  String weatherDescription;
  String weatherIcon;

  factory HourlyForecast.fromJson(Map<String, dynamic> json) => HourlyForecast(
    dt: json["dt"],
    temp: json["temp"].toDouble(),
    feels_like: json["feels_like"].toDouble(),
    pressure: json["pressure"],
    humidity: json["humidity"],
    dewPoint: json["dew_point"].toDouble(),
    clouds: json["clouds"],
    uvi: json["uvi"].toDouble(),
    visibility: json["visibility"],
    windSpeed: json["wind_speed"].toDouble(),
    windDeg: json["wind_deg"],
    pop: json["pop"].toDouble(),
    weatherId: json["weather_id"],
    weatherMain: json["weather_main"],
    weatherDescription: json["weather_description"],
    weatherIcon: json["weather_icon"],
  );

  Map<String, dynamic> toJson() => {
    "dt": dt,
    "temp": temp,
    "feels_like": feels_like,
    "pressure": pressure,
    "humidity": humidity,
    "dew_point": dewPoint,
    "clouds": clouds,
    "uvi": uvi,
    "visibility": visibility,
    "wind_speed": windSpeed,
    "wind_deg": windDeg,
    "pop": pop,
    "weather_id": weatherId,
    "weather_main": weatherMain,
    "weather_description": weatherDescription,
    "weather_icon": weatherIcon,
  };
}
