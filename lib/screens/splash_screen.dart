import 'dart:developer';

import 'package:flutter/material.dart';



class SplashScreen extends StatefulWidget{
  const SplashScreen({Key? key}) : super(key: key);


  @override
  _SplashScreenState createState() => _SplashScreenState();

}
class _SplashScreenState extends State<SplashScreen>{
  bool _isLogin = false;

  @override
  void initState(){
    // TODO: implement initState
    super.initState();

  }



  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return const MaterialApp(
      home: Scaffold(
        body: Center(
          child: Text(
            "Chuồn\n  Chuồn",
            style: TextStyle(
              fontSize: 50,
              fontWeight: FontWeight.bold,
              color: Colors.blueAccent,
            ),),
        ),
      ),
    );
  }

}