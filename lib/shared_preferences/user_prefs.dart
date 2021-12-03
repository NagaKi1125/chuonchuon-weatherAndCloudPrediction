import 'package:shared_preferences/shared_preferences.dart';

class UserPrefs {
  static SharedPreferences? _prefs;
  static const _keyIsLogin= "_keyIslogin";
  static const _keyToken = "_keyToken";
  static const _keyName = "_keyName";
  static const _keyEmail = "_keyEmail";

  static Future init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  static setLoginStatus(bool status){
    if(_prefs != null) _prefs!.setBool(_keyIsLogin, status);
  }
  static bool getLoginStatus(){
    return _prefs == null ? false : _prefs!.getBool(_keyIsLogin) ?? false;
  }

  static setUserToken(String value){
    if(_prefs != null) _prefs!.setString(_keyToken, value);
  }
  static String getToken(){
    return _prefs == null ? "Null" : _prefs!.getString(_keyToken) ?? "Null";
  }

  static setUserName(String value){
    if(_prefs != null) _prefs!.setString(_keyName, value);
  }
  static String getUserName(){
    return _prefs == null ? "Null" : _prefs!.getString(_keyName) ?? "Null";
  }

  static setUserEmail(String value){
    if(_prefs != null) _prefs!.setString(_keyEmail, value);
  }
  static String getUserEmail(){
    return _prefs == null ? "Null" : _prefs!.getString(_keyEmail) ?? "Null";
  }
}