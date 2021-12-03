import 'dart:convert';
import 'dart:io';
import 'dart:async';

import 'package:chuonchuon/models/predict_result.dart';
import 'package:chuonchuon/shared_preferences/location_preferences.dart';
import 'package:chuonchuon/shared_preferences/stuff_prefs.dart';
import 'package:chuonchuon/shared_preferences/weather_prefs.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';


class PredictResult extends StatefulWidget{
  final String imagePath;
  final String cloudName;
  const PredictResult({Key? key, required this.imagePath, required this.cloudName}) : super(key: key);

  @override
  _PredictResultState createState() => _PredictResultState();

}
class _PredictResultState extends State<PredictResult> {
  final Color _background = const Color.fromRGBO(16, 16, 59, 1);
  CloudPredictResult? _result;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loadPreferences();
    _runThings();
  }

  _runThings() async {
    await _getPredictResult(File(widget.imagePath), widget.cloudName.split('-')[1].trim());
  }

  _loadPreferences() async {
    await LocationPreferences.init();
    await WeatherPrefs.init();
    await StuffsPrefs.init();

    await StuffsPrefs.setMainURL('https://admin-chuonchuon.herokuapp.com/api/');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: _background,
          title: const Text('Kết quả nhận diện'),
      ),
      body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 300,
                  padding: const EdgeInsets.all(10),
                  child: Center(child: Image.file(File(widget.imagePath), fit: BoxFit.fill,)),
                ),
                Center(
                  child: Text(
                      widget.cloudName,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    )
                  ),
                ),
                _buildTitle(title: 'Cấu trúc của loại mây này'),
                _buildResult(result: _result == null ? "--Đang lấy thông tin--" : _result!.structure),
                const SizedBox(height: 10),
                _buildTitle(title: 'Kiểu thời tiết có thể xảy ra'),
                _buildResult(result: _result == null ? "--Đang lấy thông tin--" : _result!.weather),
                const SizedBox(height: 10),
                _buildTitle(title: 'Chú thích thêm'),
                _buildResult(result: _result == null ? "--Đang lấy thông tin--" : _result!.note),
              ],
            ),
          )
      ),
    );
  }

  Widget _buildTitle({required String title}){
    return Text(
      title,
      style: const TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 16,
      ),
    );
  }

  Widget _buildResult({required String result}){
    return Text(
      result,
      style: const TextStyle(
        fontWeight: FontWeight.w500,
        fontSize: 13,
      ),
    );
  }

  _getPredictResult(File image, String code) async {
    var stream = http.ByteStream(Stream.castFrom(image.openRead()));
    var length = await image.length();

    var uri = Uri.parse('${StuffsPrefs.getMainURL()}predict');

    var request = http.MultipartRequest("POST", uri);
    var multipart = http.MultipartFile('img', stream, length,
        filename: basename(image.path));
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      // 'Authorization': 'Bearer ${UserPreferences.getToken()}',
    };

    request.fields['code'] = code;

    // request.headers.addAll(headers);
    request.files.add(multipart);

    var response = await request.send();
    print(response.statusCode);
    if(response.statusCode == 200){

      final respStr = await response.stream.bytesToString();
      // print(respStr);
      setState(() {
        _result = CloudPredictResult.fromJson(jsonDecode(respStr));
      });
      // print(_result.cloudCode);
    }else{
      response.stream.transform(utf8.decoder).listen((event) {
        print(event);
      });
    }
  }

}