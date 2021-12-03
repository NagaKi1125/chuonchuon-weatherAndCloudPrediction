import 'dart:convert';

import 'package:chuonchuon/models/weather_hourly.dart';
import 'package:flutter/cupertino.dart';
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
  int _itemActive = 0;

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
              'Trong 7 ngày tới',
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
                  _buildTopWidget(obj: listDaily[_itemActive]),
                  Container(
                    padding: const EdgeInsets.fromLTRB(8, 15, 8, 10),
                    margin: const EdgeInsets.only(bottom: 20),
                    decoration: BoxDecoration(
                      // color: Colors.white.withOpacity(.6),
                      borderRadius: BorderRadius.circular(15),
                      // border: Border.all(color: Colors.white),
                    ),
                    width: size.width * .9,
                    height: 130,
                    child: ListView.separated(
                      separatorBuilder: (BuildContext context, int index){
                        return const SizedBox(width: 10,);
                      },
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      itemCount: listDaily.length,
                      itemBuilder: (BuildContext context, int index){
                        return InkWell(
                          onTap: (){
                            setState(() {
                              _itemActive = index;
                            });
                          },
                          child: _buildHourlyDetails(
                            active: index == _itemActive ? true : false,
                            time: listDaily[index].dt,
                            temp: '${listDaily[index].tempMax.round()}/${listDaily[index].tempMin.round()}°C',
                            icon: listDaily[index].weatherIcon,
                          ),
                        );
                      },
                    ),
                  ),

                  _buildHeadingTitle(title: 'Các chỉ số cuộc sống'),
                  _buildElementWeather(obj: listDaily[_itemActive]),

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
                      decoration: const BoxDecoration(
                        color: Colors.transparent,
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

  Widget _buildHeadingTitle({required String title}){
    return Padding(
      padding: const EdgeInsets.fromLTRB(5, 10, 0, 5),
      child: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.w700,
          fontSize: 14,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildTopWidget({required DailyForecast obj}){
    return AnimatedContainer(
      curve: Curves.fastOutSlowIn,
      padding: const EdgeInsets.fromLTRB(0, 10, 0, 20),
      duration: const Duration(milliseconds: 800),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            obj.dt,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
              color: Colors.white,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SizedBox(
                height: 100,
                width: 100,
                child: Image.network(obj.weatherIcon, fit: BoxFit.contain,),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      Text(
                        '${obj.tempMax.round()} /',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 28,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        '${obj.tempMin.round()} °C',
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 20,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10,),
                  Text(
                    obj.weatherDescription,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHourlyDetails({required bool active, required String time,
    required String temp, required String icon}){
    Color textColor = active == false ? Colors.white60 : _background;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 800),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: active == true ? Colors.white38 : Colors.transparent),
        color: active == true ? Colors.white : const Color.fromRGBO(30, 31, 69, 1),
        boxShadow: [
          active == true ?
          BoxShadow(
            color: Colors.white.withOpacity(.6),
            spreadRadius: 2,
            blurRadius: 4,
            offset: const Offset(0,0),
          ) : const BoxShadow(),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            // "${time.split(" ")[0]}\n${time.split(" ")[1]}",
              time.split(' ')[0],
              style: TextStyle(
                color: textColor,
                fontSize: 14,
              )),
          SizedBox(
            height: 20,
            width: 20,
            child: CircleAvatar(
              radius: 50,
              backgroundColor: Colors.lightBlueAccent.withOpacity(.3),
              child: Image.network(icon),
            ),
          ),
          Text(
              temp,
              style: TextStyle(
                color: textColor,
              )),
        ],
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

  Widget _buildElementWeather({required DailyForecast obj}){
    // return Text(obj.dt);
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        AnimatedContainer(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          duration: const Duration(milliseconds: 700),
          decoration: BoxDecoration(
            // border: Border.all(color: Colors.white),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            children: [
              _buildItemDailySocial(title: "Bình minh:", value: obj.sunrise),
              const SizedBox(height: 10),
              _buildItemDailySocial(title: "Hoàng hôn", value: obj.sunset),
              const SizedBox(height: 10),
              _buildItemDailySocial(title: "Trăng lên:", value: obj.moonrise),
              const SizedBox(height: 10),
              _buildItemDailySocial(title: "Trăng hạ:", value: obj.moonset),
              const SizedBox(height: 10),
              _buildItemDailySocial(title: "Pha Trăng:", value: _getMoonPhase(phase: obj.moonPhase)),
              const SizedBox(height: 10),
              _buildItemDailySocial(title: "Xác suất mưa:", value: _precipitation(pop: obj.pop)),
              const SizedBox(height: 10),
              _buildItemDailySocial(title: "Hướng gió:", value: _windDirection(degree: obj.windDeg)),
              const SizedBox(height: 10),
              _buildItemDailySocial(title: "Sức gió:", value: '${obj.windSpeed} m/s'),
              const SizedBox(height: 10),
              _buildItemDailySocial(title: "Độ ẩm:", value: '${obj.humidity}%'),
              const SizedBox(height: 10),
              _buildItemDailySocial(title: "Chỉ số UV:", value: _detectUV(uvi: obj.uvi)),
              const SizedBox(height: 10),
              _buildItemDailySocial(title: "Áp suất không khí", value: "${obj.pressure} hPa"),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildItemDailySocial({required String title, required String value}){
    double fontSize = 13;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
            title,
            style: TextStyle(
              color: Colors.white,
              fontSize: fontSize,
            )
        ),
        Text(
          value,
          style: TextStyle(
            color: Colors.white,
            fontSize: fontSize,
          ),
        )
      ],
    );
  }

  String _getMoonPhase({required double phase}){
    String text = '';
    if (phase == 0 && phase == 1){
      text = "Trăng non (sóc)";  
    } else if(phase == 0.25) {
      text = "Bán nguyệt thượng huyền";
    } else if(phase == 0.5) {
      text = "Trăng vọng";
    }else if(phase == 0.75) {
      text = "Trăng cuối quý";
    }else if(phase > 0 && phase < 0.25) {
      text = "Lưỡi liềm hạ huyền";
    }else if(phase > 0.25 && phase < 0.5) {
      text = "Trăng khuyết hạ huyền";
    }else if(phase > 0.5 && phase < 0.75) {
      text = "Trăng khuyết thượng huyền";
    }else if(phase > 0.75 && phase < 1) {
      text = "Lưỡi liềm thượng huyền";
    }
    return text;
  }

  String _precipitation({required double pop}){
    String text = "";
    double height = 0;
    pop = pop * 100;
    if(pop < 20){
      text = "Không có mưa";
    }else if(pop >=20 && pop < 30){
      text = "Khả năng thấp";
    }else if(pop >= 30 && pop < 50){
      text = "Có thể có mưa";
    }else{
      text = "Mưa";
    }

    return '${pop.round()}% - $text';
  }

  String _windDirection({required int degree}){
    List<String> _directions = ["N - Bắc", "NNE - Bắc Đông Bắc", "NE - Đông Bắc", "ENE - Đông Đông Bắc", "E - Đông",
      "ESE - Đông Đông Nam", "SE - Đông Nam", "SSE - Nam Đông Nam", "S - Nam", "SSW - Nam Tây Nam",
      "SW - Tây Nam", "WSW - Tây Tây Nam", "W - Tây", "WNW - Tây Tây Bắc",
      "NW - Tây Bắc", "NNW - Bắc Tây Bắc"];
    int val = ((degree / 22.5) + 0.5).round();

    return _directions[(val % 16)];
  }

  String _detectUV({required double uvi}){
    String text = "";
    if(uvi >= 0 && uvi <= 2){
      text = "Thấp";
    }else if(uvi >= 8 && uvi <= 10){
      text = "Gây hại";
    }else if(uvi >= 11){
      text = "Rất nguy hiểm";
    }else{
      text = "Bình thường";
    }
    return "$uvi - $text";
  }


}

