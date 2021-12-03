import 'dart:convert';

import 'package:chuonchuon/models/register_user.dart';
import 'package:chuonchuon/screens/home.dart';
import 'package:chuonchuon/screens/login.dart';
import 'package:chuonchuon/shared_preferences/stuff_prefs.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:developer';

class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {

  final Color _background = const Color.fromRGBO(16, 16, 59, 1);
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _rePassController = TextEditingController();

  RegisterUser? _register;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Đăng ký'),
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
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _createTextField(title: "Nhập tên của bạn", type: 0, controller: _nameController),
          _createTextField(title: "Nhập email", type: 0, controller: _emailController),
          _createTextField(title: "Nhập mật khẩu", type: 1, controller: _passwordController),
          _createTextField(title: "Nhập lại mật khẩu", type: 1, controller: _rePassController),
          TextButton(
            onPressed: (){
              // Get.snackbar(
              //   'Chuồn chuồn',
              //   'Register activated',
              //   snackPosition: SnackPosition.BOTTOM,
              // );
              register(
                  name: _nameController.text,
                  email: _emailController.text,
                  password: _passwordController.text,
                  rePass: _rePassController.text
              );
            },
            child: Container(
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
              decoration: BoxDecoration(
                color: Colors.lightBlueAccent,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Text(
                'Đăng ký',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
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

  register({required String name, required String email, required String password,
    required String rePass}) async {
    if(password.compareTo(rePass) == 0){
      Map data = {
        'name': name,
        'email': email,
        'password': password,
        'confirm_password':rePass
      };

      var response = await http.post(Uri.parse('${StuffsPrefs.getMainURL()}auth/register'), body: data);
      print(response.statusCode);

      if(response.statusCode == 201){
        var jsonData = jsonDecode(response.body);
        setState(() {
          _register = RegisterUser.fromJson(jsonData['user']);
        });
        Get.snackbar(
            "Chuồn Chuồn",
            'Đăng ký tài khoản thành công, chào mừng ${_register!.name}',
            snackPosition: SnackPosition.BOTTOM);


        Get.to( () => const Login());

      }else{
        Get.snackbar(
            "Chuồn Chuồn",
            'Đã xảy ra lỗi, vui lòng thử lại sau',
            snackPosition: SnackPosition.BOTTOM);
        log(response.body);
      }
    }else{
      Get.snackbar(
          "Chuồn Chuồn",
          'Xác nhận mật khẩu chưa khớp',
          snackPosition: SnackPosition.BOTTOM);
    }


  }
}
