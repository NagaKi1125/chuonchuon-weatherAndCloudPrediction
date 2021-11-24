import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:chuonchuon/models/weather_current.dart';
import 'package:chuonchuon/models/weather_daily.dart';
import 'package:chuonchuon/models/weather_hourly.dart';
import 'package:chuonchuon/shared_preferences/location_preferences.dart';
import 'package:chuonchuon/shared_preferences/stuff_prefs.dart';
import 'package:chuonchuon/shared_preferences/weather_prefs.dart';

class SlidingWidget extends StatefulWidget{
  final int type;
  final ScrollController controller;
  const SlidingWidget({Key? key,required this.type, required this.controller}) : super(key: key);

  @override
  _SlidingWidgetState createState() => _SlidingWidgetState();

}

class _SlidingWidgetState extends State<SlidingWidget> {
  CurrentWeather? currentWeather;
  List<DailyForecast>? listDaily;
  List<HourlyForecast>? listHourly;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loadPreferences();
    _formatWeatherObject();
  }

  _loadPreferences() async {
    await LocationPreferences.init();
    await WeatherPrefs.init();
    await StuffsPrefs.init();
  }

  _formatWeatherObject() {
    currentWeather = CurrentWeather.fromJson(
        jsonDecode(WeatherPrefs.getCurrentWeatherJson()));
    listDaily =
        (json.decode(WeatherPrefs.getDailyForecastJson()) as List).map((e) =>
            DailyForecast.fromJson(e)).toList();
    listHourly =
        (json.decode(WeatherPrefs.getHourlyForecastJson()) as List).map((e) =>
            HourlyForecast.fromJson(e)).toList();
  }


  @override
  Widget build(BuildContext context) {

    Widget slide = const SizedBox(height: 150);

    if(widget.type == 1){
      slide = SizedBox(
        height: 150,
        child: ListView(
          controller: widget.controller,
          shrinkWrap: true,
          children: [


            GridView.count(
              crossAxisCount: 2,
              childAspectRatio: 3,
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              children: <Widget>[
                // uns
                _buildListTileDetails(
                  icon: 'assets/icons/sunrise.png',
                  title: "Mặt trời mọc",
                  value: currentWeather!.sunrise,
                ),
                _buildListTileDetails(
                  icon: 'assets/icons/sunset.png',
                  title: "Mặt trời lặn",
                  value: currentWeather!.sunset,
                ),

                _buildListTileDetails(
                  icon: 'assets/icons/pressure.png',
                  title: "Áp suất",
                  value: '${currentWeather!.pressure} hPa',
                ),
                _buildListTileDetails(
                  icon: 'assets/icons/humidity.png',
                  title: "Độ ẩm",
                  value: '${currentWeather!.humidity}%',
                ),
                _buildListTileDetails(
                  icon: 'assets/icons/uv.png',
                  title: "Chỉ số UV",
                  value: '${currentWeather!.uvi}',
                ),
                _buildListTileDetails(
                  icon: 'assets/icons/visibility.png',
                  title: "Tầm nhìn",
                  value: "${(currentWeather!.visibility/1000).round()} km",
                ),
                _buildListTileDetails(
                  icon: 'assets/icons/wind_speed.png',
                  title: "Sức gió",
                  value: "${currentWeather!.windSpeed} m/s",
                ),
                ListTile(
                  leading: SizedBox(
                    width: 40, height: 40,
                    child: RotationTransition(
                      turns: AlwaysStoppedAnimation(currentWeather!.windDeg/360),
                      child: Image.asset('assets/icons/wind_deg.png'),
                    ),
                  ),
                  title: const Text("Hướng gió"),
                  subtitle: Text(_windDirection(degree: currentWeather!.windDeg)) ,
                ),
                _buildListTileDetails(
                  icon: 'assets/icons/dew_point.png',
                  title: "Điểm sương",
                  value: '${currentWeather!.dewPoint}°C',
                ),
              ],
            ),
          ],
        ),
      );
    }else if(widget.type == 2){
      // hourly
      slide = SizedBox(
        height: 150,
        child: ListView.separated(
          separatorBuilder: (BuildContext context, int index){
            return const SizedBox(width: 5,);
          },
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          itemCount: 20,
          itemBuilder: (BuildContext context, int index){
            return _buildHourlyDetails(
              time: listHourly![index].dt,
              temp: '${listHourly![index].temp.round()}°C',
              icon: listHourly![index].weatherIcon,
              weather: listHourly![index].weatherDescription,
            );
          },
        ),
      );
    }else if(widget.type == 3){
      //daily
      slide = SizedBox(
        height: 150,
        child: ListView.builder(
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          itemCount: 7,
          itemBuilder: (BuildContext context, int index){
            // double temp = (listDaily![index].tempMin + listDaily![index].tempMax)/2;
            return _buildDailyDetails(
              time: listDaily![index].dt,
              temp: '${listDaily![index].tempMin.round()} / ${listDaily![index].tempMax.round()}°C',
              icon: listDaily![index].weatherIcon,
              weather: listDaily![index].weatherDescription,
            );
          },
        ),
      );
    }

    return slide;
  }

  String _windDirection({required int degree}){
    List<String> _directions = ["N","NNE","NE","ENE","E","ESE", "SE", "SSE","S",
      "SSW","SW","WSW","W","WNW","NW","NNW"];
    int val = ((degree / 22.5) + 0.5).round();

    return _directions[(val % 16)];
  }

  Widget _buildDailyDetails({required String time, required String temp, required String icon, required String weather}){
    return Container(
      padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(time),
          Container(
              width: 60,
              height: 60 ,
              decoration: BoxDecoration(
                color: Colors.grey.withOpacity(.2),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Image.network(icon)
          ),
          Text(weather, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w400),),
          Text(temp),
        ],
      ),
    );
  }

  Widget _buildListTileDetails(
      {required String icon, required String title, required String value}) {
    return ListTile(
      leading: SizedBox(width:40, height: 40,child: Image.asset(icon)),
      title: Text(title),
      subtitle: Text(value) ,
    );
  }

  Widget _buildHourlyDetails({required String time, required String temp, required String icon, required String weather}){
    return Container(
      decoration: BoxDecoration(
        // color: Colors.lightBlueAccent.withOpacity(.3),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(time),
            Container(
              width: 60,
              height: 60 ,
              decoration: BoxDecoration(
                color: Colors.grey.withOpacity(.2),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Image.network(icon)
            ),
            Text(weather, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w400),),
            Text(temp),
          ],
        ),
      ),
    );
  }

}


