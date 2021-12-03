import 'dart:convert';

import 'package:chuonchuon/models/login_response.dart';
import 'package:chuonchuon/screens/home.dart';
import 'package:chuonchuon/screens/register.dart';
import 'package:chuonchuon/shared_preferences/stuff_prefs.dart';
import 'package:chuonchuon/shared_preferences/user_prefs.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  LoginUser? user;
  bool _isLogin = false;
  String _token = 'null';
  TextEditingController _emailController = new TextEditingController();
  TextEditingController _passwordController = new TextEditingController();


  final Color _background = const Color.fromRGBO(16, 16, 59, 1);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loadPreferences();
  }

  _loadPreferences() async {
    await UserPrefs.init();
    await StuffsPrefs.init();
    _isLogin = UserPrefs.getLoginStatus();
    _token = UserPrefs.getToken();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Đăng nhập'),
          elevation: 0,
          backgroundColor: _background,
          actions: [
            IconButton(
              onPressed: () {
                Get.to(() => const Home());
              },
              icon: const Icon(Icons.home),
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Container(
            height: size.height * .9,
            padding: const EdgeInsets.fromLTRB(8, 0, 8, 30),
            decoration: BoxDecoration(
              color: _background,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildLogo(),
                _buildBody(),
              ],
            ),
          )
        ),
      ),
    );
  }

  Widget _buildLogo(){
    return Container(
      padding: const EdgeInsets.all(16),
      child: const Text(
        "Chuồn\n  Chuồn",
        style: TextStyle(
          fontSize: 50,
          fontWeight: FontWeight.bold,

          color: Colors.white,
        )
        ,),
    );
  }

  Widget _buildBody(){
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _createTextField(title: "Nhập email", type: 0, controller: _emailController),
        _createTextField(title: "Nhập mật khẩu", type: 1, controller: _passwordController),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextButton(
              onPressed: (){
                // Get.snackbar(
                //   'Chuồn chuồn',
                //   'Login activated',
                //   snackPosition: SnackPosition.BOTTOM,
                // );
                _login(email: _emailController.text, password: _passwordController.text);
              },
              child: Container(
                padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                decoration: BoxDecoration(
                  color: Colors.lightBlueAccent,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Text(
                  'Đăng nhập',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            TextButton(
              onPressed: (){
                Get.to( () => const Register());
              },
              child: const Text(
                'Đăng ký tài khoản >>',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
  
  Widget _createTextField({required String title, required int type, required TextEditingController controller}){
    return  Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 20),
      child: TextFormField(
        controller: controller,
        style: const TextStyle(
          color: Colors.white,
        ),
        obscureText: type == 1 ? true : false,
        decoration: InputDecoration(
          enabledBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.white60),
          ),
          labelText: title,
          floatingLabelStyle: const TextStyle(
            color: Colors.white,
          ),
          labelStyle: const TextStyle(
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  _login({required String email, required String password}) async {
    Map data = {
      'email': email,
      'password': password,
    };

    var response = await http.post(Uri.parse('${StuffsPrefs.getMainURL()}auth/login'), body: data);
    print(response.statusCode);
    if(response.statusCode == 200){
      var responseData = jsonDecode(response.body);
      // print(responseData);

      setState((){

        user = LoginUser.fromJson(responseData['user']);
        _isLogin = true;
        _token = responseData['access_token'];
      });

      await UserPrefs.setLoginStatus(_isLogin);
      await UserPrefs.setUserToken(_token);
      await UserPrefs.setUserName(user!.name);
      await UserPrefs.setUserEmail(user!.email);

      Get.snackbar(
          'Chuồn Chuồn',
          "Đăng nhập thành công, chào mừng ${user!.name}",
          snackPosition: SnackPosition.BOTTOM);


      await Future.delayed(const Duration(seconds: 4));
      Get.to(() => const Home());

    }else{
      Get.snackbar("Chuồn Chuồn",
      "Không thể đăng nhập. Xin vui lòng kiểm tra lại email và mật khẩu của bạn",
      snackPosition: SnackPosition.BOTTOM);
    }



  }
}
