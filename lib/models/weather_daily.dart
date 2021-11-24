import 'dart:convert';

DailyForecast dailyForecastFromJson(String str) => DailyForecast.fromJson(json.decode(str));

String dailyForecastToJson(DailyForecast data) => json.encode(data.toJson());

class DailyForecast {
  DailyForecast({
    required this.dt,
    required this.sunrise,
    required this.sunset,
    required this.moonrise,
    required this.moonset,
    required this.moonPhase,
    required this.tempMorn,
    required this.tempDay,
    required this.tempEve,
    required this.tempNight,
    required this.tempMin,
    required this.tempMax,
    required this.pressure,
    required this.humidity,
    required this.dewPoint,
    required this.windSpeed,
    required this.windDeg,
    required this.clouds,
    required this.pop,
    required this.uvi,
    required this.weatherId,
    required this.weatherMain,
    required this.weatherDescription,
    required this.weatherIcon,
  });

  String dt;
  String sunrise;
  String sunset;
  String moonrise;
  String moonset;
  double moonPhase;
  double tempMorn;
  double tempDay;
  double tempEve;
  double tempNight;
  double tempMin;
  double tempMax;
  int pressure;
  int humidity;
  double dewPoint;
  double windSpeed;
  int windDeg;
  int clouds;
  double pop;
  double uvi;
  int weatherId;
  String weatherMain;
  String weatherDescription;
  String weatherIcon;

  factory DailyForecast.fromJson(Map<String, dynamic> json) => DailyForecast(
    dt: json["dt"],
    sunrise: json["sunrise"],
    sunset: json["sunset"],
    moonrise: json["moonrise"],
    moonset: json["moonset"],
    moonPhase: json["moon_phase"].toDouble(),
    tempMorn: json["temp_morn"].toDouble(),
    tempDay: json["temp_day"].toDouble(),
    tempEve: json["temp_eve"].toDouble(),
    tempNight: json["temp_night"].toDouble(),
    tempMin: json["temp_min"].toDouble(),
    tempMax: json["temp_max"].toDouble(),
    pressure: json["pressure"],
    humidity: json["humidity"],
    dewPoint: json["dew_point"].toDouble(),
    windSpeed: json["wind_speed"].toDouble(),
    windDeg: json["wind_deg"],
    clouds: json["clouds"],
    pop: json["pop"].toDouble(),
    uvi: json["uvi"].toDouble(),
    weatherId: json["weather_id"],
    weatherMain: json["weather_main"],
    weatherDescription: json["weather_description"],
    weatherIcon: json["weather_icon"],
  );

  Map<String, dynamic> toJson() => {
    "dt": dt,
    "sunrise": sunrise,
    "sunset": sunset,
    "moonrise": moonrise,
    "moonset": moonset,
    "moon_phase": moonPhase,
    "temp_morn": tempMorn,
    "temp_day": tempDay,
    "temp_eve": tempEve,
    "temp_night": tempNight,
    "temp_min": tempMin,
    "temp_max": tempMax,
    "pressure": pressure,
    "humidity": humidity,
    "dew_point": dewPoint,
    "wind_speed": windSpeed,
    "wind_deg": windDeg,
    "clouds": clouds,
    "pop": pop,
    "uvi": uvi,
    "weather_id": weatherId,
    "weather_main": weatherMain,
    "weather_description": weatherDescription,
    "weather_icon": weatherIcon,
  };
}
