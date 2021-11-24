import 'package:chuonchuon/screens/home.dart';
import 'package:chuonchuon/screens/register.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {

  final Color _background = const Color.fromRGBO(16, 16, 59, 1);

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
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _createTextField(title: "Nhập email", type: 0),
          _createTextField(title: "Nhập mật khẩu", type: 1),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton(
                onPressed: (){
                  Get.snackbar(
                    'Chuồn chuồn',
                    'Login activated',
                    snackPosition: SnackPosition.BOTTOM,
                  );
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
      ),
    );
  }
  
  Widget _createTextField({required String title, required int type}){
    return  Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 20),
      child: TextFormField(
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
}
