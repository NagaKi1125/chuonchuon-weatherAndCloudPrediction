import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:chuonchuon/models/weather_daily.dart';
import 'package:chuonchuon/shared_preferences/location_preferences.dart';
import 'package:chuonchuon/shared_preferences/stuff_prefs.dart';
import 'package:chuonchuon/shared_preferences/weather_prefs.dart';

class DailyLineChart extends StatefulWidget{
  final int type;
  final TooltipBehavior tooltipBehavior;
  const DailyLineChart({Key? key, required this.type, required this.tooltipBehavior}) : super(key: key);

  @override
  _DailyLineChartState createState() => _DailyLineChartState();

}

class _DailyLineChartState extends State<DailyLineChart>{

  List<DailyForecast> listDaily = [];
  List<TempDataMinMax> minMaxList = [];
  List<TempDataDayNight> dayNightList = [];
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
    listDaily =
        (json.decode(WeatherPrefs.getDailyForecastJson()) as List).map((e) =>
            DailyForecast.fromJson(e)).toList();
    for(var i =0; i < listDaily.length; i++){
      // double temp = (listDaily[i].tempMin + listDaily[i].tempMax) /2;
      minMaxList.add(TempDataMinMax(listDaily[i].dt,listDaily[i].tempMin, listDaily[i].tempMax ));
      dayNightList.add(TempDataDayNight(
          listDaily[i].dt,listDaily[i].tempMorn, listDaily[i].tempDay,
          listDaily[i].tempEve, listDaily[i].tempNight
      ));
      humidityList.add(HumidityData(listDaily[i].dt, listDaily[i].humidity));
      windSpeedList.add(WindSpeedData(listDaily[i].dt, listDaily[i].windSpeed));
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget sfDailyLineChart = SfCartesianChart();
    if(widget.type == 1) {
      sfDailyLineChart = SfCartesianChart(
        enableAxisAnimation: true,
        title: ChartTitle(text: "Biểu đồ nhiệt độ trong 7 ngày tới",
            textStyle: const TextStyle(
              fontSize: 12,
            )),
        legend: Legend(isVisible: true, position: LegendPosition.bottom),
        tooltipBehavior: widget.tooltipBehavior,
        series: <CartesianSeries>[
          SplineSeries<TempDataMinMax, String>(
            name: 'Nhiệt độ cao nhất',
            xAxisName: "Giờ",
            yAxisName: 'Nhiệt độ',
            dataSource: minMaxList,
            xValueMapper: (TempDataMinMax data, _) => data.time,
            yValueMapper: (TempDataMinMax data, _) => data.max.round(),
            dataLabelSettings: const DataLabelSettings(
              isVisible: true,
            ),
            enableTooltip: true,
            color: Colors.orangeAccent,
          ),
          SplineSeries<TempDataMinMax, String>(
            name: 'Nhiệt độ thấp nhất',
            xAxisName: "Giờ",
            yAxisName: 'Nhiệt độ',
            dataSource: minMaxList,
            xValueMapper: (TempDataMinMax data, _) => data.time,
            yValueMapper: (TempDataMinMax data, _) => data.min.round(),
            dataLabelSettings: const DataLabelSettings(
              isVisible: true,
            ),
            enableTooltip: true,
            color: Colors.lightBlueAccent,
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
    } else if(widget.type == 2){
      sfDailyLineChart = SfCartesianChart(
        enableAxisAnimation: true,
        title: ChartTitle(text:"Biểu đồ nhiệt độ trong 7 ngày tới",
            textStyle: const TextStyle(
              fontSize: 12,
            )),
        legend: Legend(isVisible: true, position: LegendPosition.bottom,
            textStyle: const TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w600,
            )),
        tooltipBehavior: widget.tooltipBehavior,
        series: <CartesianSeries>[
          SplineSeries<TempDataDayNight, String>(
            name: 'Buổi sáng',
            xAxisName: "Giờ",
            yAxisName: 'Nhiệt độ',
            dataSource: dayNightList,
            xValueMapper: (TempDataDayNight data, _) => data.time,
            yValueMapper: (TempDataDayNight data, _) => data.morn.round(),
            dataLabelSettings: const DataLabelSettings(
              isVisible: false,
            ),
            enableTooltip: true,
            color: Colors.lightBlue,
          ),
          SplineSeries<TempDataDayNight, String>(
            name: 'Trong ngày',
            xAxisName: "Giờ",
            yAxisName: 'Nhiệt độ',
            dataSource: dayNightList,
            xValueMapper: (TempDataDayNight data, _) => data.time,
            yValueMapper: (TempDataDayNight data, _) => data.day.round(),
            dataLabelSettings: const DataLabelSettings(
              isVisible: true,
            ),
            enableTooltip: true,
            color: Colors.orangeAccent,
          ),
          SplineSeries<TempDataDayNight, String>(
            name: 'Buổi tối',
            xAxisName: "Giờ",
            yAxisName: 'Nhiệt độ',
            dataSource: dayNightList,
            xValueMapper: (TempDataDayNight data, _) => data.time,
            yValueMapper: (TempDataDayNight data, _) => data.eve.round(),
            dataLabelSettings: const DataLabelSettings(
              isVisible: false,
            ),
            enableTooltip: true,
            color: Colors.greenAccent,
          ),
          SplineSeries<TempDataDayNight, String>(
            name: 'Đêm khuya',
            xAxisName: "Giờ",
            yAxisName: 'Nhiệt độ',
            dataSource: dayNightList,
            xValueMapper: (TempDataDayNight data, _) => data.time,
            yValueMapper: (TempDataDayNight data, _) => data.night.round(),
            dataLabelSettings: const DataLabelSettings(
              isVisible: true,
            ),
            enableTooltip: true,
            color: Colors.white38,
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
    }else if(widget.type == 3){
      sfDailyLineChart = SfCartesianChart(
        enableAxisAnimation: true,
        title: ChartTitle(text: "Biểu đồ độ ẩm trong 7 ngày tới",
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
    }else if(widget.type == 4){
      sfDailyLineChart = SfCartesianChart(
        enableAxisAnimation: true,
        title: ChartTitle(text: "Biểu đồ sức gió trong 7 ngày tới",
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

    return sfDailyLineChart;
  }

}


class TempDataMinMax {
  TempDataMinMax(this.time, this.min, this.max);
  final String time;
  final double min;
  final double max;
}

class TempDataDayNight{
  TempDataDayNight(this.time, this.morn, this.day, this.eve, this.night);
  final String time;
  final double morn;
  final double day;
  final double eve;
  final double night;
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
