import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:chuonchuon/models/weather_hourly.dart';
import 'package:chuonchuon/shared_preferences/location_preferences.dart';
import 'package:chuonchuon/shared_preferences/stuff_prefs.dart';
import 'package:chuonchuon/shared_preferences/weather_prefs.dart';

class HourlyLineChart extends StatefulWidget{
  final int type;
  final TooltipBehavior tooltipBehavior;
  const HourlyLineChart({Key? key, required this.type, required this.tooltipBehavior}) : super(key: key);

  @override
  _HourlyLineChartState createState() => _HourlyLineChartState();

}

class _HourlyLineChartState extends State<HourlyLineChart>{

  List<HourlyForecast> listHourly = [];
  List<TempData> tempList = [];
  List<HumidityData> humidityList = [];
  List<WindSpeedData> windSpeedList = [];


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
    listHourly =
        (json.decode(WeatherPrefs.getHourlyForecastJson()) as List).map((e) =>
            HourlyForecast.fromJson(e)).toList();
    for(var i =0; i < listHourly.length; i++){
      if(i % 5 == 0){
        tempList.add(TempData(listHourly[i].dt, listHourly[i].temp));
        humidityList.add(HumidityData(listHourly[i].dt, listHourly[i].humidity));
        windSpeedList.add(WindSpeedData(listHourly[i].dt, listHourly[i].windSpeed));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget sfHourlyLineChart = SfCartesianChart();
    if(widget.type == 1){
      sfHourlyLineChart = SfCartesianChart(
        enableAxisAnimation: true,
        title: ChartTitle(text:"Biểu đồ nhiệt độ trong 48 giờ tới",
            textStyle: const TextStyle(
              fontSize: 12,
            )),
        legend: Legend(isVisible: true, position: LegendPosition.bottom),
        tooltipBehavior: widget.tooltipBehavior,
        series: <SplineSeries>[
          SplineSeries<TempData, String>(
            name: 'Nhiệt độ',
            xAxisName: "Giờ",
            yAxisName: 'Nhiệt độ',
            dataSource: tempList,
            xValueMapper: (TempData data, _) => data.time,
            yValueMapper: (TempData data, _) => data.temps.round(),
            dataLabelSettings: const DataLabelSettings(
              isVisible: true,
              color: Colors.black26,
            ),
            enableTooltip: true,
            color: Colors.orangeAccent,
          ),
        ],
        primaryXAxis: CategoryAxis(
          autoScrollingDelta: 10,
          majorGridLines: const MajorGridLines(width: 0),
          interval: 1,
        ),
        primaryYAxis: NumericAxis(
          labelFormat: '{value}°C',
          majorGridLines: const MajorGridLines(width: 0),
          isVisible: false,
        ),
      );
    }else if(widget.type == 2){
        sfHourlyLineChart = SfCartesianChart(
          enableAxisAnimation: true,
          title: ChartTitle(text: "Biểu đồ độ ẩm trong 48 giờ tới",
              textStyle: const TextStyle(
                fontSize: 12,
              )),
          legend: Legend(isVisible: true, position: LegendPosition.bottom),
          tooltipBehavior: widget.tooltipBehavior,
          series: <SplineSeries>[
            SplineSeries<HumidityData, String>(
              name: 'Độ ẩm',
              xAxisName: 'Giờ',
              yAxisName: 'Độ ẩm',
              dataSource: humidityList,
              xValueMapper: (HumidityData data, _) => data.time,
              yValueMapper: (HumidityData data, _) => data.humi,
              dataLabelSettings: const DataLabelSettings(
                isVisible: true,
                color: Colors.black26,
              ),
              enableTooltip: true,
              color: Colors.lightBlueAccent,
            ),
          ],
          primaryXAxis: CategoryAxis(
            majorGridLines: const MajorGridLines(width: 0),
            interval: 1,
          ),
          primaryYAxis: NumericAxis(
            labelFormat: '{value}%',
            majorGridLines: const MajorGridLines(width: 0),
            isVisible: false,
          ),
        );
    }else if(widget.type == 3){
      sfHourlyLineChart = SfCartesianChart(
        enableAxisAnimation: true,
        title: ChartTitle(text: "Biểu đồ sức gió trong 48 giờ tới",
            textStyle: const TextStyle(
              fontSize: 12,
            )),
        legend: Legend(isVisible: true, position: LegendPosition.bottom),
        tooltipBehavior: widget.tooltipBehavior,
        series: <SplineSeries>[
          SplineSeries<WindSpeedData, String>(
            name: 'Sức gió',
            xAxisName: 'Giờ',
            yAxisName: 'Sức gió',
            dataSource: windSpeedList,
            xValueMapper: (WindSpeedData data, _) => data.time,
            yValueMapper: (WindSpeedData data, _) => data.windSpeed,
            dataLabelSettings: const DataLabelSettings(
              isVisible: true,
              color: Colors.black26,
            ),
            enableTooltip: true,
            color: Colors.greenAccent,
          ),
        ],
        primaryXAxis: CategoryAxis(
          autoScrollingDelta: 10,
          majorGridLines: const MajorGridLines(width: 0),
          interval: 1,
        ),
        primaryYAxis: NumericAxis(
          labelFormat: '{value} m/s',
          majorGridLines: const MajorGridLines(width: 0),
          isVisible: false,
        ),
      );
    }

    return sfHourlyLineChart;
  }

}


class TempData {
  TempData(this.time, this.temps);
  final String time;
  final double temps;
}

class HumidityData{
  HumidityData(this.time, this.humi);
  final String time;
  final int humi;
}

class WindSpeedData{
  WindSpeedData(this.time, this.windSpeed);
  final String time;
  final double windSpeed;
}
