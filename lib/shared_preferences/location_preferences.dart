import 'package:shared_preferences/shared_preferences.dart';

class LocationPreferences{
  static SharedPreferences? _preferences;
  static const _keyLatitude = '_latitude';
  static const _keyLongitude = '_longitude';
  static const _keyAddress = '_address';
  static const _keySubAdminAddress = "_subAdminAddress";

  static Future init() async {
    _preferences = await SharedPreferences.getInstance();
  }

  static setLatitude(double value){
    if(_preferences != null) _preferences!.setDouble(_keyLatitude, value);
  }
  static double getLatitude(){
    return _preferences == null ? 0 : _preferences!.getDouble(_keyLatitude) ?? 0;
  }

  static setLongitude(double value){
    if(_preferences != null) _preferences!.setDouble(_keyLongitude, value);
  }
  static double getLongitude(){
    return _preferences == null ? 0 : _preferences!.getDouble(_keyLongitude) ?? 0;
  }

  static setFullAddress(String value){
    if(_preferences != null) _preferences!.setString(_keyAddress, value);
  }
  static String getFullAddress(){
    return _preferences == null ? "_VN" : _preferences!.getString(_keyAddress) ?? "_VN";
  }

  static setSubAdminAddress(String value){
      if(_preferences != null) _preferences!.setString(_keyAddress, value);
    }
    static String getSubAdminAddress(){
      return _preferences == null ? "_VN" : _preferences!.getString(_keyAddress) ?? "_VN";
    }

}