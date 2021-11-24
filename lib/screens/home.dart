import 'dart:convert';
import 'dart:developer';
import 'package:chuonchuon/screens/login.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:chuonchuon/models/weather_current.dart';
import 'package:chuonchuon/parts/sliding_panel_up.dart';
import 'package:chuonchuon/parts/navigation_drawer.dart';
import 'package:chuonchuon/shared_preferences/location_preferences.dart';
import 'package:chuonchuon/shared_preferences/stuff_prefs.dart';
import 'package:chuonchuon/shared_preferences/weather_prefs.dart';
import 'package:percent_indicator/percent_indicator.dart';

class Home extends StatefulWidget{
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home>{

  final GlobalKey<ScaffoldState> _globalKey = GlobalKey<ScaffoldState>();
  CurrentWeather? currentWeather;
  final Color _background = const Color.fromRGBO(16, 16, 59, 1);
  double sunPercent = 0.5;
  @override
  void initState() {
    super.initState();
    _loadLocationPreferences();
    _formatWeatherObject();
  }

  _loadLocationPreferences() async {
    await LocationPreferences.init();
    await WeatherPrefs.init();
    await StuffsPrefs.init();
  }

  _formatWeatherObject(){
    currentWeather = CurrentWeather.fromJson(jsonDecode(WeatherPrefs.getCurrentWeatherJson()));
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    // log("data: ${WeatherPrefs.getDailyForecastJson()}");
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      key: _globalKey,
      drawer: const NavigationDrawerWidget(active: 1),
      appBar: AppBar(
        backgroundColor: _background,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.search_sharp,size: 30, color: Colors.white),
            onPressed: (){
              Get.snackbar(
                "Chuồn Chuồn",
                "Search Activate",
                snackPosition: SnackPosition.BOTTOM,
              );
            },
          ),
          IconButton(
              onPressed: (){
                Get.to( () => const Login());
              },
              icon: const Icon(Icons.account_circle))
        ],
      ),
      body: SlidingUpPanel(
        color: Colors.white,
        minHeight: size.height * 0.03,
        maxHeight: size.height * 0.35,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        body: Container(
          padding: const EdgeInsets.fromLTRB(8, 0, 8, 30),
          decoration: BoxDecoration(
            color: _background,
          ),
          // design screen
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Top header childs
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(11, 0, 0, 0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          LocationPreferences.getSubAdminAddress(),
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height:3),
                        Text(
                          'Cập nhật lần cuối ${currentWeather!.dt}',
                          style: const TextStyle(
                            fontWeight: FontWeight.normal,
                            fontSize: 12,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(
                          width: 100,
                          child: Image.network(currentWeather!.weatherIcon, fit: BoxFit.contain,)
                        ),
                        Text(
                            currentWeather!.weatherDescription,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                  InkWell(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(0, 0, 8, 0),
                      child: Text(
                        '${currentWeather!.temp.round()}°',
                        style: const TextStyle(
                          fontSize: 80,
                          fontWeight: FontWeight.bold,
                          color: Colors.white
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              // sun
              Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(5),
                    width: size.width,
                    child: LinearPercentIndicator(
                      animation: true,
                      lineHeight: 6,
                      animationDuration: 2500,
                      percent: _calculateSunPercent(
                          sunrise: currentWeather!.sunrise,
                          sunset: currentWeather!.sunset,
                      ),
                      leading: _buildText(
                        text: currentWeather!.sunrise,
                        icon: 'assets/icons/sunrise.png',
                      ),
                      trailing: _buildText(
                        text: currentWeather!.sunset,
                        icon: 'assets/icons/sunset.png',
                      ),
                      linearStrokeCap: LinearStrokeCap.roundAll,
                      // progressColor: Colors.orangeAccent,
                      addAutomaticKeepAlive: true,
                      backgroundColor: Colors.transparent,
                      linearGradient: const LinearGradient(
                        colors: [Colors.orangeAccent, Colors.orange,
                          Colors.deepOrange,Colors.orange, Colors.indigoAccent, Colors.indigo]
                      ),
                    ),
                  ),
                  // bottom short details
                  Container(
                    margin: const EdgeInsets.fromLTRB(0, 0, 0, 80),
                    width: size.width * 0.9,
                    height: size.height * 0.12,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.white,width: 2),
                      color: Colors.blueAccent.withOpacity(.3),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildDetailsColumn(
                          title: "Độ ẩm",
                          value: '${currentWeather!.humidity} %',
                        ),
                        const Padding(
                          padding: EdgeInsets.fromLTRB(0, 20, 0, 20),
                          child: VerticalDivider(color: Colors.white, thickness: 1.0,),
                        ),
                        _buildDetailsColumn(
                          title: "Áp suất",
                          value: '${currentWeather!.pressure} hPa',
                        ),
                        const Padding(
                          padding: EdgeInsets.fromLTRB(0, 20, 0, 20),
                          child: VerticalDivider(color: Colors.white, thickness: 1.0,),
                        ),
                        _buildDetailsColumn(
                          title: "Sức gió",
                          value: '${currentWeather!.windSpeed} m/s',
                        ),
                      ],
                    ),
                  ),
                ],
              ),

            ],
          ),
        ),
        panelBuilder: (controller) => PanelSlidingUp(
          controller: controller,
        ),
      ),
    );
  }

  Widget _buildText({required String text, required String icon}){
    return Column(
      children: [
        SizedBox(
          width: 35,
          child: Image.asset(icon, fit: BoxFit.contain,),
        ),
        Text(
          text,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 11,
          ),
        ),
      ],
    );
  }
  Widget _buildDetailsColumn({required String title,required String value}){
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white70,
            fontWeight: FontWeight.normal,
            fontSize: 18
          ),
        ),
      ],
    );
  }

  double _calculateSunPercent({required String sunrise, required String sunset }){
    String rise = sunrise.split(" ")[0];
    String set = sunset.split(' ')[0];

    double riseMinute = double.parse(rise.split(":")[0]) * 60 + double.parse(rise.split(":")[1]);
    double setMinute = double.parse(set.split(":")[0]) * 60 + double.parse(set.split(":")[1]);

    var now = DateTime.now();
    double nowMinute = now.hour.toDouble() * 60 + now.minute.toDouble();

    double total = setMinute - riseMinute;
    double current = nowMinute - riseMinute;

    double percent = current/total;
    return percent > 0 && percent <= 1 ? percent : 1;


  }
}

