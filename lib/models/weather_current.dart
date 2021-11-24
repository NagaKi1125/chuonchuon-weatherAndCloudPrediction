import 'dart:convert';

CurrentWeather currentWeatherFromJson(String str) => CurrentWeather.fromJson(json.decode(str));

String currentWeatherToJson(CurrentWeather data) => json.encode(data.toJson());

class CurrentWeather {
  CurrentWeather({
    required this.dt,
    required this.sunrise,
    required this.sunset,
    required this.temp,
    required this.feelsLike,
    required this.pressure,
    required this.humidity,
    required this.dewPoint,
    required this.clouds,
    required this.uvi,
    required this.visibility,
    required this.windSpeed,
    required this.windDeg,
    required this.weatherId,
    required this.weatherMain,
    required this.weatherDescription,
    required this.weatherIcon,
  });

  String dt;
  String sunrise;
  String sunset;
  double temp;
  double feelsLike;
  int pressure;
  int humidity;
  double dewPoint;
  int clouds;
  double uvi;
  int visibility;
  double windSpeed;
  int windDeg;
  int weatherId;
  String weatherMain;
  String weatherDescription;
  String weatherIcon;

  factory CurrentWeather.fromJson(Map<String, dynamic> json) => CurrentWeather(
    dt: json["dt"],
    sunrise: json["sunrise"],
    sunset: json["sunset"],
    temp: json["temp"].toDouble(),
    feelsLike: json["feels_like"].toDouble(),
    pressure: json["pressure"],
    humidity: json["humidity"],
    dewPoint: json["dew_point"].toDouble(),
    clouds: json["clouds"],
    uvi: json["uvi"].toDouble(),
    visibility: json["visibility"],
    windSpeed: json["wind_speed"].toDouble(),
    windDeg: json["wind_deg"],
    weatherId: json["weather_id"],
    weatherMain: json["weather_main"],
    weatherDescription: json["weather_description"],
    weatherIcon: json["weather_icon"],
  );

  Map<String, dynamic> toJson() => {
    "dt": dt,
    "sunrise": sunrise,
    "sunset": sunset,
    "temp": temp,
    "feels_like": feelsLike,
    "pressure": pressure,
    "humidity": humidity,
    "dew_point": dewPoint,
    "clouds": clouds,
    "uvi": uvi,
    "visibility": visibility,
    "wind_speed": windSpeed,
    "wind_deg": windDeg,
    "weather_id": weatherId,
    "weather_main": weatherMain,
    "weather_description": weatherDescription,
    "weather_icon": weatherIcon,
  };
}
