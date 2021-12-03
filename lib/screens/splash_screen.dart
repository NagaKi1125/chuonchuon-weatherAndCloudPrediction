import 'dart:developer';

import 'package:chuonchuon/shared_preferences/user_prefs.dart';
import 'package:flutter/material.dart';



class SplashScreen extends StatefulWidget{
  const SplashScreen({Key? key}) : super(key: key);


  @override
  _SplashScreenState createState() => _SplashScreenState();

}
class _SplashScreenState extends State<SplashScreen>{
  bool _isLogin = false;
  String _token = "null";

  @override
  void initState(){
    // TODO: implement initState
    super.initState();
  _loadPreferences();
  }

  _loadPreferences() async {
    await UserPrefs.init();
    _isLogin = UserPrefs.getLoginStatus();
    _token = UserPrefs.getToken();
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