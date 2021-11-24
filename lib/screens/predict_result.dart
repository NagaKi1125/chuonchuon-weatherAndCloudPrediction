import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
class PredictResult extends StatefulWidget{
  final String imagePath;
  final String cloudName;
  const PredictResult({Key? key, required this.imagePath, required this.cloudName}) : super(key: key);

  @override
  _PredictResultState createState() => _PredictResultState();

}
class _PredictResultState extends State<PredictResult> {
  final Color _background = const Color.fromRGBO(16, 16, 59, 1);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: _background,
          title: const Text('Kết quả nhận diện'),
      ),
      body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                height: 300,
                padding: const EdgeInsets.all(10),
                child: Center(child: Image.file(File(widget.imagePath), fit: BoxFit.fill,)),
              ),
              Center(
                child: Text(
                    widget.cloudName,
                  style: const TextStyle()
                ),
              ),
            ],
          )
      ),
    );
  }
}