
import 'dart:async';
import 'package:camera/camera.dart';
import 'package:chuonchuon/shared_preferences/location_preferences.dart';
import 'package:chuonchuon/shared_preferences/stuff_prefs.dart';
import 'package:chuonchuon/shared_preferences/user_prefs.dart';
import 'package:chuonchuon/shared_preferences/weather_prefs.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:chuonchuon/screens/home.dart';
import 'package:chuonchuon/screens/splash_screen.dart';
import 'package:geocoding/geocoding.dart' as geocoding;
import 'package:location/location.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

List<CameraDescription> cameras = [];

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  cameras = await availableCameras();
  runApp(const SplashScreen());
  await fetchData();
}

fetchData() async {
  await _loadPreferences();
  await _setURL();
  await locationServices();
  Timer(const Duration(seconds: 5), () => runApp(const Main()));
}

_setURL() async {
  await StuffsPrefs.setMainURL('https://admin-chuonchuon.herokuapp.com/api/');
  await StuffsPrefs.setWeatherURl('${StuffsPrefs.getMainURL()}weather-now');
}

_loadPreferences() async {
  await LocationPreferences.init();
  await WeatherPrefs.init();
  await StuffsPrefs.init();
  await UserPrefs.init();

  if((UserPrefs.getLoginStatus()==false) || (UserPrefs.getLoginStatus() == null)){
    await UserPrefs.setLoginStatus(false);
  }else{
    await UserPrefs.setLoginStatus(true);
  }

}

Future<void> locationServices() async {
  Location location = Location();
  bool _serviceEnabled;
  PermissionStatus _locationPermit;
  LocationData _locData;

  _serviceEnabled = await location.serviceEnabled();
  if(!_serviceEnabled){
    _serviceEnabled = await location.requestService();
    if(!_serviceEnabled){
      return;
    }
  }

  _locationPermit = await location.hasPermission();
  if(_locationPermit == PermissionStatus.denied){
    _locationPermit = await location.requestPermission();
    if(_locationPermit != PermissionStatus.granted){
      return;
    }
  }

  _locData = await location.getLocation();
  // log("_location Data:$_locData}");

  //parse value
  await LocationPreferences.setLatitude(_locData.latitude!);
  await LocationPreferences.setLongitude(_locData.longitude!);


  // log("lat: 1.${LocationPreferences.getLatitude()} - 2." + LocationPreferences.getLatitude().toString());
  // log("lon: 1.${LocationPreferences.getLongitude()} - 2." + LocationPreferences.getLongitude().toString());

  await _getAddressFromLatLon(
    lat: _locData.latitude!,
    lon: _locData.longitude!,
  );

  await _getWeatherDetails(
      lat: LocationPreferences.getLatitude(),
      lon: LocationPreferences.getLongitude(),
      type: 0
  );
}

Future<void> _getAddressFromLatLon({required double lat, required double lon}) async {
  List<geocoding.Placemark> placeMarks = await geocoding.placemarkFromCoordinates(lat, lon);
  geocoding.Placemark place = placeMarks[0];
  String _address = '${place.subAdministrativeArea}, ${place.administrativeArea}, ${place.country}';

  //parse value
  await LocationPreferences.setFullAddress(_address);
  await LocationPreferences.setSubAdminAddress('${place.subAdministrativeArea}');
  // log("address: "+ _address);
}

Future<String> _getWeatherDetails({required double lat, required double lon, required int type}) async {
  Map formBody = {
    'lat': lat.toString(),
    'lon': lon.toString(),
    'type': type.toString(),
  };
  String jsonData;

  var response = await http.post(Uri.parse(StuffsPrefs.getWeatherURL()), body: formBody);
  if(response.statusCode == 200){
    jsonData = response.body;
    final Map<String, dynamic> res = json.decode(jsonData);
    // log("current: ${res['current']}");
    // log('*************************************');
    // log("hourly: ${res['hourly']}");
    // log('*************************************');
    // log("daily: ${res['daily']}");
    await WeatherPrefs.setCurrentWeather(jsonEncode(res['current']));
    await WeatherPrefs.setHourlyForecast(jsonEncode(res['hourly']));
    await WeatherPrefs.setDailyForecast(jsonEncode(res['daily']));
  }else{
    jsonData = response.body;
  }

  return jsonData;

}



class Main extends StatefulWidget {
  const Main({Key? key}) : super(key: key);

  @override
  _MainState createState() => _MainState();
}

class _MainState extends State<Main>{
  @override
  Widget build(BuildContext context) {
    return const GetMaterialApp(
      debugShowCheckedModeBanner: false,
      home: Home(),
    );
  }
}