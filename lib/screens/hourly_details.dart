import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:chuonchuon/models/weather_hourly.dart';
import 'package:chuonchuon/parts/hourly_line_chart.dart';
import 'package:chuonchuon/parts/navigation_drawer.dart';
import 'package:chuonchuon/shared_preferences/location_preferences.dart';
import 'package:chuonchuon/shared_preferences/stuff_prefs.dart';
import 'package:chuonchuon/shared_preferences/weather_prefs.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class HourlyDetails extends StatefulWidget{
  const HourlyDetails({Key? key}) : super(key: key);

  @override
  _HourlyDetailsState createState() => _HourlyDetailsState();

}

class _HourlyDetailsState extends State<HourlyDetails>{

  final GlobalKey<ScaffoldState> _globalKey = GlobalKey<ScaffoldState>();
  List<HourlyForecast> listHourly = [];
  final Color _background = const Color.fromRGBO(16, 16, 59, 1);

  bool _tempChartActive = true;
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
    listHourly =
        (json.decode(WeatherPrefs.getHourlyForecastJson()) as List).map((e) =>
            HourlyForecast.fromJson(e)).toList();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    Size size = MediaQuery.of(context).size;

    return SafeArea(
      child: Scaffold(
        key: _globalKey,
        drawer: const NavigationDrawerWidget(active: 2),
        appBar: AppBar(
          backgroundColor: _background,
          elevation: 0,
          title: const Text(
            'Trong 48 gi??? ti???p theo',
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

                _buildHourlyActive(obj: listHourly[_itemActive]),
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
                    itemCount: listHourly.length,
                    itemBuilder: (BuildContext context, int index){
                      return InkWell(
                        onTap: (){
                          setState(() {
                            _itemActive = index;
                          });
                        },
                        child: _buildHourlyDetails(
                          active: index == _itemActive ? true : false,
                          time: listHourly[index].dt,
                          temp: '${listHourly[index].temp.round()}??C',
                          icon: listHourly[index].weatherIcon,
                        ),
                      );
                    },
                  ),
                ),
                
                _buildHeadingTitle(title: 'C??c ch??? s??? cu???c s???ng'),
                _buildElementWeather(obj: listHourly[_itemActive]),


                _buildHeadingTitle(title: 'Bi???u ????? ph??n t??ch'),
                Padding(
                  padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      TextButton(
                        child: _buildButton(
                            name: "Nhi???t ?????",
                            active: _tempChartActive,
                        ),
                        onPressed: (){
                          setState(() {
                            _tempChartActive = true;
                            _windChartActive = false;
                            _humidityChartActive = false;
                            _active = 1;
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
                            _tempChartActive = false;
                            _windChartActive = false;
                            _humidityChartActive = true;
                            _active = 2;
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
                            _tempChartActive = false;
                            _windChartActive = true;
                            _humidityChartActive = false;
                            _active = 3;
                          });
                        },
                      ),
                    ],
                  ),
                ),

                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 700),
                  child: Container(
                      decoration: const BoxDecoration(
                        color: Colors.transparent,
                        // border: Border.all(color: Colors.white),
                        // borderRadius: BorderRadius.circular(20),
                      ),
                      child: HourlyLineChart(type: _active, tooltipBehavior: _tooltipBehavior!,),
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

  Widget _buildElementWeather({required HourlyForecast obj}){
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
              _buildItemHourlySocial(title: "X??c su???t m??a:", value: _precipitation(pop: obj.pop)),
              const SizedBox(height: 10),
              _buildItemHourlySocial(title: "H?????ng gi??:", value: _windDirection(degree: obj.windDeg)),
              const SizedBox(height: 10),
              _buildItemHourlySocial(title: "S???c gi??:", value: '${obj.windSpeed} m/s'),
              const SizedBox(height: 10),
              _buildItemHourlySocial(title: "????? ???m:", value: '${obj.humidity}%'),
              const SizedBox(height: 10),
              _buildItemHourlySocial(title: "Ch??? s??? UV:", value: _detectUV(uvi: obj.uvi)),
              const SizedBox(height: 10),
              _buildItemHourlySocial(title: "??p su???t kh??ng kh??", value: "${obj.pressure} hPa")
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildItemHourlySocial({required String title, required String value}){
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

  Widget _buildHourlyActive({required HourlyForecast obj}){
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
              fontWeight: FontWeight.w600,
              fontSize: 16,
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
                  Text(
                    '${obj.temp}??C',
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 28,
                      color: Colors.white,
                    ),
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

  Widget _buildListTileDetails(
      {required String icon, required String title, required String value}) {
    return ListTile(
      leading: SizedBox(width:40, height: 40,child: Image.asset(icon)),
      title: Text(title),
      subtitle: Text(value) ,
    );
  }
    
}

