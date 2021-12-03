import 'package:shared_preferences/shared_preferences.dart';

class StuffsPrefs {
  static SharedPreferences? _prefs;
  static const _keyMainURL = "_keyMainURL";
  static const _keyWeatherURL = "_keyWeatherURL";
  static const String _mainURL = "https://admin-chuonchuon.herokuapp.com/api/";

  static Future init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  static setMainURL(String value){
    if(_prefs != null) _prefs!.setString(_keyMainURL, value);
  }
  static String getMainURL(){
    return _prefs == null ? _mainURL : _prefs!.getString(_keyMainURL) ?? _mainURL;
  }

  static setWeatherURl(String value){
    if(_prefs != null) _prefs!.setString(_keyWeatherURL, value);
  }
  static String getWeatherURL(){
    return _prefs == null ? _mainURL+"weather-now" : _prefs!.getString(_keyWeatherURL) ?? _mainURL+'weather-now';
  }
}