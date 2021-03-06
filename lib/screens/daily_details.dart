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
              'Trong 7 ng??y t???i',
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
                            temp: '${listDaily[index].tempMax.round()}/${listDaily[index].tempMin.round()}??C',
                            icon: listDaily[index].weatherIcon,
                          ),
                        );
                      },
                    ),
                  ),

                  _buildHeadingTitle(title: 'C??c ch??? s??? cu???c s???ng'),
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
                              name: "Nhi???t ????? min/max",
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
                              name: "Nhi???t ????? trong ng??y",
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
                              name: "????? ???m",
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
                              name: "S???c gi??",
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
                        '${obj.tempMin.round()} ??C',
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
              _buildItemDailySocial(title: "B??nh minh:", value: obj.sunrise),
              const SizedBox(height: 10),
              _buildItemDailySocial(title: "Ho??ng h??n", value: obj.sunset),
              const SizedBox(height: 10),
              _buildItemDailySocial(title: "Tr??ng l??n:", value: obj.moonrise),
              const SizedBox(height: 10),
              _buildItemDailySocial(title: "Tr??ng h???:", value: obj.moonset),
              const SizedBox(height: 10),
              _buildItemDailySocial(title: "Pha Tr??ng:", value: _getMoonPhase(phase: obj.moonPhase)),
              const SizedBox(height: 10),
              _buildItemDailySocial(title: "X??c su???t m??a:", value: _precipitation(pop: obj.pop)),
              const SizedBox(height: 10),
              _buildItemDailySocial(title: "H?????ng gi??:", value: _windDirection(degree: obj.windDeg)),
              const SizedBox(height: 10),
              _buildItemDailySocial(title: "S???c gi??:", value: '${obj.windSpeed} m/s'),
              const SizedBox(height: 10),
              _buildItemDailySocial(title: "????? ???m:", value: '${obj.humidity}%'),
              const SizedBox(height: 10),
              _buildItemDailySocial(title: "Ch??? s??? UV:", value: _detectUV(uvi: obj.uvi)),
              const SizedBox(height: 10),
              _buildItemDailySocial(title: "??p su???t kh??ng kh??", value: "${obj.pressure} hPa"),
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
      text = "Tr??ng non (s??c)";  
    } else if(phase == 0.25) {
      text = "B??n nguy???t th?????ng huy???n";
    } else if(phase == 0.5) {
      text = "Tr??ng v???ng";
    }else if(phase == 0.75) {
      text = "Tr??ng cu???i qu??";
    }else if(phase > 0 && phase < 0.25) {
      text = "L?????i li???m h??? huy???n";
    }else if(phase > 0.25 && phase < 0.5) {
      text = "Tr??ng khuy???t h??? huy???n";
    }else if(phase > 0.5 && phase < 0.75) {
      text = "Tr??ng khuy???t th?????ng huy???n";
    }else if(phase > 0.75 && phase < 1) {
      text = "L?????i li???m th?????ng huy???n";
    }
    return text;
  }

  String _precipitation({required double pop}){
    String text = "";
    double height = 0;
    pop = pop * 100;
    if(pop < 20){
      text = "Kh??ng c?? m??a";
    }else if(pop >=20 && pop < 30){
      text = "Kh??? n??ng th???p";
    }else if(pop >= 30 && pop < 50){
      text = "C?? th??? c?? m??a";
    }else{
      text = "M??a";
    }

    return '${pop.round()}% - $text';
  }

  String _windDirection({required int degree}){
    List<String> _directions = ["N - B???c", "NNE - B???c ????ng B???c", "NE - ????ng B???c", "ENE - ????ng ????ng B???c", "E - ????ng",
      "ESE - ????ng ????ng Nam", "SE - ????ng Nam", "SSE - Nam ????ng Nam", "S - Nam", "SSW - Nam T??y Nam",
      "SW - T??y Nam", "WSW - T??y T??y Nam", "W - T??y", "WNW - T??y T??y B???c",
      "NW - T??y B???c", "NNW - B???c T??y B???c"];
    int val = ((degree / 22.5) + 0.5).round();

    return _directions[(val % 16)];
  }

  String _detectUV({required double uvi}){
    String text = "";
    if(uvi >= 0 && uvi <= 2){
      text = "Th???p";
    }else if(uvi >= 8 && uvi <= 10){
      text = "G??y h???i";
    }else if(uvi >= 11){
      text = "R???t nguy hi???m";
    }else{
      text = "B??nh th?????ng";
    }
    return "$uvi - $text";
  }


}

