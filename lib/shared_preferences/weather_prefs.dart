import 'package:shared_preferences/shared_preferences.dart';

class WeatherPrefs{
  static SharedPreferences? _prefs;

  static const _keyCurrent = "current";
  static const _keyDaily = "daily";
  static const _keyHourly = "hourly";

  static Future init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // current weather condition
  static setCurrentWeather(String currentJsonValue){
    if(_prefs != null) _prefs!.setString(_keyCurrent, currentJsonValue);
  }
  static String getCurrentWeatherJson() =>
      _prefs == null ? "Code01: Something went wrong" : _prefs!.getString(_keyCurrent) ?? "Code01: Api fetched error";

  // hourly forecast
  static setHourlyForecast(String hourlyJsonValue){
    if(_prefs != null) _prefs!.setString(_keyHourly, hourlyJsonValue);
  }
  static String getHourlyForecastJson() =>
      _prefs == null ? "Code02: Something went wrong" : _prefs!.getString(_keyHourly) ?? "Code02: Api fetched error";

  // daily forecast
  static setDailyForecast(String dailyJsonValue){
    if(_prefs != null) _prefs!.setString(_keyDaily, dailyJsonValue);
  }
  static String getDailyForecastJson() =>
      _prefs == null ? "Code03: Something went wrong" : _prefs!.getString(_keyDaily) ?? "Code03: Api fetched error";
}