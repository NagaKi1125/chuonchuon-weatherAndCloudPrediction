import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:chuonchuon/parts/sliding_items.dart';
import 'package:chuonchuon/shared_preferences/location_preferences.dart';
import 'package:chuonchuon/shared_preferences/stuff_prefs.dart';
import 'package:chuonchuon/shared_preferences/weather_prefs.dart';

class PanelSlidingUp extends StatefulWidget{
  final ScrollController controller;
  const PanelSlidingUp({Key? key, required this.controller}) : super(key: key);

  @override
  _SlidingUpState createState() => _SlidingUpState();

}

class _SlidingUpState extends State<PanelSlidingUp> {

  String _title = 'Thời tiết hiện tại';
  bool _currentActive = true;
  bool _hourlyActvive = false;
  bool _dailyActive = false;
  int _type = 1;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loadPreferences();
  }

  _loadPreferences() async {
    await LocationPreferences.init();
    await WeatherPrefs.init();
    await StuffsPrefs.init();
  }


  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const SizedBox(height: 10,),
        _buildDragHandle(),
        Padding(
          padding: const EdgeInsets.fromLTRB(10, 5, 0, 0),
          child: Text(
            _title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              letterSpacing: .5,
              fontSize: 16,
            ),
          ),
        ),
        const Divider(color: Colors.black45),
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 700),
          child: SlidingWidget(type: _type, controller: widget.controller),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            TextButton(
              child: _buildTextButton(
                title: "Hiện tại",
                isActivated: _currentActive,
              ),
              onPressed: () {
                setState(() {
                  _currentActive = true;
                  _dailyActive = false;
                  _hourlyActvive = false;
                  _title = "Thời tiết hiện tại";
                  _type = 1;
                });
              },
            ),
            TextButton(
              child: _buildTextButton(
                title: "Theo giờ",
                isActivated: _hourlyActvive,
              ),
              onPressed: () {
                setState(() {
                  _currentActive = false;
                  _dailyActive = false;
                  _hourlyActvive = true;
                  _title = "Dự báo hàng giờ";
                  _type = 2;
                });
              },
            ),
            TextButton(
              child: _buildTextButton(
                title: "Theo ngày",
                isActivated: _dailyActive,
              ),
              onPressed: () {
                setState(() {
                  _currentActive = false;
                  _dailyActive = true;
                  _hourlyActvive = false;
                  _title = "Dự báo 7 ngày";
                  _type = 3;
                });
              },
            ),
          ],
        )
      ],
    );
  }


  Widget _buildTextButton({required String title, required bool isActivated}) {
    return Text(
      title,
      style: TextStyle(
        fontWeight: isActivated == true ? FontWeight.bold : FontWeight.normal,
        color: isActivated == true ? Colors.black : Colors.black26,
      ),
    );
  }

  Widget _buildDragHandle() =>
      Center(
        child: Container(
          width: 60,
          height: 6,
          decoration: BoxDecoration(
            color: Colors.black26,
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );

}