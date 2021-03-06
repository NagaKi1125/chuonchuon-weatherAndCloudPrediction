import 'dart:convert';

import 'package:chuonchuon/models/weather_current.dart';
import 'package:chuonchuon/models/weather_daily.dart';
import 'package:chuonchuon/models/weather_hourly.dart';
import 'package:chuonchuon/shared_preferences/stuff_prefs.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:country_state_city_picker/country_state_city_picker.dart';
import 'package:geocoding/geocoding.dart' as geocoding;
import 'package:http/http.dart' as http;
import 'package:percent_indicator/linear_percent_indicator.dart';

class CitySearch extends StatefulWidget{
  const CitySearch({Key? key}) : super(key: key);

  @override
  _CitySearchState createState() => _CitySearchState();

}

class _CitySearchState extends State<CitySearch>{

  final Color _background = const Color.fromRGBO(16, 16, 59, 1);
  String countryValue = "country";
  String stateValue = "state";
  String cityValue = "city";
  String googleAPIkey = "AIzaSyAmmeemmyqkk_mP9Q4MfoY32WLzuFO5XOQ";
  String geoLocation = "";

  CurrentWeather? currentWeather;
  List<DailyForecast>? listDaily;
  List<HourlyForecast>? listHourly;

  String jsonData ='';

  bool _isSearch = true;

  bool _hourlyActive = true;
  bool _dailyActive = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getLatLonFromAddress(address: "Gronausestraat 710, Enschede");
  }

  Future<String> _getLatLonFromAddress({required String address}) async {
    List<geocoding.Location> location = await geocoding.locationFromAddress(address);
    geocoding.Location geo = location[0];
    String _address = '${geo.latitude}, ${geo.longitude}';
    setState(() {
      geoLocation = _address;
    });

    return _address;
  }

  Future<String> _getWeatherDetails({required double lat, required double lon, required int type}) async {
    Map formBody = {
      'lat': lat.toString(),
      'lon': lon.toString(),
      'type': type.toString(),
    };
    String jsonData;
    String message;
    var response = await http.post(Uri.parse(StuffsPrefs.getWeatherURL()), body: formBody);
    if(response.statusCode == 200){
      jsonData = response.body;

      final Map<String, dynamic> res = json.decode(jsonData);

      _formatWeatherObject(res);


      message = "Th??nh c??ng";
    }else{
      message = response.body;
    }
    return message;
  }

  _formatWeatherObject(jsonResponse) {
    CurrentWeather current = CurrentWeather.fromJson(jsonResponse['current']);
    List<DailyForecast> lDaily =
        (jsonResponse['daily'] as List).map((e) =>
            DailyForecast.fromJson(e)).toList();
    List<HourlyForecast> lHourly =
        (jsonResponse['hourly'] as List).map((e) =>
            HourlyForecast.fromJson(e)).toList();

    setState(() {
      currentWeather = current;
      listDaily = lDaily;
      listHourly = lHourly;
    });
  }


  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: _background,
          title: const Text('Tra c???u th??nh ph???'),
        ),
        body: SingleChildScrollView(
          child: Container(
            height: size.height,
            decoration: BoxDecoration(
              color: _background,
            ),
            width: size.width,
            padding: const EdgeInsets.fromLTRB(8, 10, 8, 30),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Visibility(
                  visible: _isSearch,
                  child: Column(
                    children: [
                      SelectState(
                        dropdownColor: _background,
                        style: const TextStyle(
                          color: Colors.white,
                        ),
                        onCountryChanged: (value) {
                          setState(() {
                            countryValue = value;
                          });
                        },
                        onStateChanged:(value) {
                          setState(() {
                            stateValue = value;
                          });
                        },
                        onCityChanged:(value) {
                          setState(() {
                            cityValue = value;
                          });
                        },
                      ),


                      // Text(geoLocation),
                      // Text(jsonData),
                    ],
                  ),
                ),
                Text('$countryValue, $stateValue $cityValue', style: const TextStyle( color: Colors.white)),
                _isSearch == true ?
                Container(
                  margin: const EdgeInsets.all(5),
                  padding: const EdgeInsets.fromLTRB(2, 0, 2, 0),
                  decoration: BoxDecoration(
                    color: Colors.indigo,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: TextButton(
                    onPressed: () async {
                      String address = '$cityValue - $stateValue - $countryValue';
                      String geo= await _getLatLonFromAddress(address: address);
                      String json = await _getWeatherDetails(
                          lat: double.parse(geo.split(',')[0]),
                          lon: double.parse(geo.split(',')[1]),
                          type: 0
                      );

                      setState((){
                        geoLocation = geo;
                        _isSearch = false;
                      });

                      Get.snackbar(
                        'Chu???n chu???n',
                        json,
                        snackPosition: SnackPosition.BOTTOM,
                      );
                    },
                    child: Text('Xem th???i ti???t ??? ????y'),
                  ),
                ) :
                Container(
                  margin: const EdgeInsets.all(5),
                  padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
                  decoration: BoxDecoration(
                    color: Colors.indigo,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: TextButton(
                    onPressed: (){
                      setState(() {
                        _isSearch = true;
                      });
                    },
                    child: Text('T??m th??nh ph???'),
                  ),
                ),
                const Divider(color:Colors.white),

                _isSearch == false ?
                _buildDetailsSearchResult(size) :
                const Center(
                  child: Text('Ch???n m???t th??nh ph??? ????? xem', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16,)),
                )
              ]
            )
          ),
        ),
      ),
    );
  }


  Widget _buildDetailsSearchResult(Size size){
    return Container(
      padding: const EdgeInsets.all(5),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            currentWeather!.dt,
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
                child: Image.network(currentWeather!.weatherIcon, fit: BoxFit.contain,),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    '${currentWeather!.temp}??C',
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 28,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 10,),
                  Text(
                    currentWeather!.weatherDescription,
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

          _buildElementWeather(obj: currentWeather!),
          
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              TextButton(
                child: _buildButton(
                  name: "H??ng gi???",
                  active: _hourlyActive,
                ),
                onPressed: (){
                  setState(() {
                    _hourlyActive = true;
                    _dailyActive = false;
                  });
                },
              ),
              TextButton(
                child: _buildButton(
                  name: "7 ng??y",
                  active: _dailyActive,
                ),
                onPressed: (){
                  setState(() {
                    _hourlyActive = false;
                    _dailyActive = true;
                  });
                },
              ),
            ],
          ),
          Visibility(
            visible: _hourlyActive,
            child: _buildHourlyList(size),
          ),
          Visibility(
            visible: _dailyActive,
            child: _buildDailyList(size),
          ),

        ],
      ),
    );
  }

  Widget _buildElementWeather({required CurrentWeather obj}){
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
              _buildItemSocial(title: "X??c su???t m??a:", value: _precipitation(pop: listHourly![0].pop)),
              const SizedBox(height: 10),
              _buildItemSocial(title: "H?????ng gi??:", value: _windDirection(degree: obj.windDeg)),
              const SizedBox(height: 10),
              _buildItemSocial(title: "S???c gi??:", value: '${obj.windSpeed} m/s'),
              const SizedBox(height: 10),
              _buildItemSocial(title: "????? ???m:", value: '${obj.humidity}%'),
              const SizedBox(height: 10),
              _buildItemSocial(title: "Ch??? s??? UV:", value: _detectUV(uvi: obj.uvi)),
              const SizedBox(height: 10),
              _buildItemSocial(title: "??p su???t kh??ng kh??", value: "${obj.pressure} hPa")
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDailyList(Size size){
    return Container(
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
        itemCount: listDaily!.length,
        itemBuilder: (BuildContext context, int index){
          return _buildHourlyDetails(
            active: false,
            time: listDaily![index].dt,
            temp: '${listDaily![index].tempMax.round()}/${listDaily![index].tempMin.round()}??C',
            icon: listDaily![index].weatherIcon,
          );
        },
      ),
    );
  }

  Widget _buildHourlyList(Size size){
    return Container(
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
        itemCount: listHourly!.length,
        itemBuilder: (BuildContext context, int index){
          return _buildHourlyDetails(
            active: false,
            time: listHourly![index].dt,
            temp: '${listHourly![index].temp.round()}??C',
            icon: listHourly![index].weatherIcon,
          );
        },
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


  Widget _buildItemSocial({required String title, required String value}){
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