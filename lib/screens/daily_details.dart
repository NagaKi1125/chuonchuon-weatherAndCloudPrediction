import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:chuonchuon/models/weather_daily.dart';
import 'package:chuonchuon/parts/daily_line_chart.dart';
import 'package:chuonchuon/parts/hourly_line_chart.dart';
import 'package:chuonchuon/parts/navigation_drawer.dart';
import 'package:chuonchuon/shared_preferences/location_preferences.dart';
import 'package:chuonchuon/shared_preferences/stuff_prefs.dart';
import 'package:chuonchuon/shared_preferences/weather_prefs.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class DailyDetails extends StatefulWidget{
  const DailyDetails({Key? key}) : super(key: key);

  @override
  _DailyDetailsState createState() => _DailyDetailsState();

}

class _DailyDetailsState extends State<DailyDetails>{

  final GlobalKey<ScaffoldState> _globalKey = GlobalKey<ScaffoldState>();
  List<DailyForecast> listDaily = [];
  final Color _background = const Color.fromRGBO(16, 16, 59, 1);

  bool _tempMinMaxActive = true;
  bool _tempDayNightActive = false;
  bool _windChartActive = false;
  bool _humidityChartActive = false;

  TooltipBehavior? _tooltipBehavior;
  int _active = 1;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loadPreferences();
    _formatWeatherObject();
    _tooltipBehavior = TooltipBehavior(enable: true);
  }

  _loadPreferences() async {
    await LocationPreferences.init();
    await WeatherPrefs.init();
    await StuffsPrefs.init();
  }

  _formatWeatherObject() {
    listDaily =
        (json.decode(WeatherPrefs.getDailyForecastJson()) as List).map((e) =>
            DailyForecast.fromJson(e)).toList();
  }


  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    Size size = MediaQuery.of(context).size;

    return SafeArea(
      child: Scaffold(
          key: _globalKey,
          drawer: const NavigationDrawerWidget(active: 3),
          appBar: AppBar(
            backgroundColor: _background,
            elevation: 0,
            title: const Text(
              'Chi tiết dự báo thời tiết theo ngày',
              style: TextStyle(

              ),
            ),
          ),
          body:  SingleChildScrollView(
            child: Container(
              width: size.width,
              padding: const EdgeInsets.fromLTRB(8, 0, 8, 30),
              decoration: BoxDecoration(
                color: _background,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                    padding: const EdgeInsets.fromLTRB(8, 15, 8, 10),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(.6),
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(color: Colors.white),
                    ),
                    width: size.width * .9,
                    height: 150,
                    child: ListView.separated(
                      separatorBuilder: (BuildContext context, int index){
                        return const SizedBox(width: 5,);
                      },
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      itemCount: listDaily.length,
                      itemBuilder: (BuildContext context, int index){
                        double temp = (listDaily[index].tempMin + listDaily[index].tempMax) /2;
                        return _buildHourlyDetails(
                          active: index == 0 ? true : false,
                          time: listDaily[index].dt,
                          temp: '${temp.round()}°C',
                          icon: listDaily[index].weatherIcon,
                          weather: listDaily[index].weatherDescription,
                        );
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          TextButton(
                            child: _buildButton(
                              name: "Nhiệt độ min/max",
                              active: _tempMinMaxActive,
                            ),
                            onPressed: (){
                              setState(() {
                                _tempMinMaxActive = true;
                                _tempDayNightActive = false;
                                _windChartActive = false;
                                _humidityChartActive = false;
                                _active = 1;
                              });
                            },
                          ),
                          TextButton(
                            child: _buildButton(
                              name: "Nhiệt độ trong ngày",
                              active: _tempDayNightActive,
                            ),
                            onPressed: (){
                              setState(() {
                                _tempMinMaxActive = false;
                                _tempDayNightActive = true;
                                _windChartActive = false;
                                _humidityChartActive = false;
                                _active = 2;
                              });
                            },
                          ),
                          TextButton(
                            child: _buildButton(
                              name: "Độ ẩm",
                              active: _humidityChartActive,
                            ),
                            onPressed: (){
                              setState(() {
                                _tempMinMaxActive = false;
                                _tempDayNightActive = false;
                                _windChartActive = false;
                                _humidityChartActive = true;
                                _active = 3;
                              });
                            },
                          ),
                          TextButton(
                            child: _buildButton(
                              name: "Sức gió",
                              active: _windChartActive,
                            ),
                            onPressed: (){
                              setState(() {
                                _tempMinMaxActive = false;
                                _tempDayNightActive = false;
                                _windChartActive = true;
                                _humidityChartActive = false;
                                _active = 4;
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 700),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white38,
                        border: Border.all(color: Colors.white),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: DailyLineChart(type: _active, tooltipBehavior: _tooltipBehavior!,),
                    ),
                  ),
                ],
              ),
            ),
          )
      ),
    );
  }

  Widget _buildButton({required String name, required bool active}){
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white),
        borderRadius: BorderRadius.circular(15),
        color: active == true ? Colors.white : Colors.transparent,
      ),
      child: Text(
        name,
        style: TextStyle(
          color: active == true ? _background : Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 13,
        ),
      ),
    );
  }

  Widget _buildHourlyDetails({required bool active, required String time, required String temp,
    required String icon, required String weather}){

    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: active == true ? Colors.white : Colors.transparent),
        color: active == true ? Colors.white.withOpacity(.5) : Colors.transparent,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(time),
          SizedBox(width: 60, height: 60 ,child: Image.network(icon)),
          Text(weather, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w400),),
          Text(temp),
        ],
      ),
    );
  }

}

