import 'package:chuonchuon/screens/camera.dart';
import 'package:chuonchuon/screens/login.dart';
import 'package:chuonchuon/shared_preferences/stuff_prefs.dart';
import 'package:chuonchuon/shared_preferences/user_prefs.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:chuonchuon/screens/live_camera.dart';
import 'package:chuonchuon/screens/daily_details.dart';
import 'package:chuonchuon/screens/home.dart';
import 'package:chuonchuon/screens/hourly_details.dart';

import '../main.dart';

class NavigationDrawerWidget extends StatefulWidget {
  final int active;

  const NavigationDrawerWidget({Key? key, required this.active}) : super(key: key);

  @override
  _NavigationState createState() => _NavigationState();
}
class _NavigationState extends State<NavigationDrawerWidget>{
  final padding = const EdgeInsets.symmetric(horizontal: 20);
  bool _isLogin = false;
  String _token = "null";

  @override
  void initState() {
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
    return Drawer(
      child: Material(
        color: Colors.white.withOpacity(.8),
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const SizedBox(height: 30,),
            _isLogin == false ?
            buildUserPart(
              name: 'Chuồn chuồn',
              email: 'chuonchuon.chuonchuon@vku.udn.vn',
              ava: 'assets/sun.png',
            ):
            buildUserPart(
                name: UserPrefs.getUserName(),
                email: UserPrefs.getUserEmail(),
                ava: 'assets/sun.png'),
            const Divider(color: Colors.black26),
            buildMenuItemIconImage(
              text: "Thời tiết hiện tại",
              icon: 'assets/icons/current.png',
              navigate: 1,
              active: widget.active == 1 ? 1 : 0 ,
            ),
            buildMenuItemIconImage(
              text: 'Dự báo theo giờ',
              icon: 'assets/icons/hourly.png',
              navigate: 2,
              active: widget.active == 2 ? 1 : 0 ,
            ),
            buildMenuItemIconImage(
              text: 'Dự báo theo ngày',
              icon: 'assets/icons/daily.png',
              navigate: 3,
              active: widget.active == 3 ? 1 : 0,
            ),
            buildMenuItemIconImage(
              text: "Thời tiết qua nhận diện đám mây",
              icon: 'assets/icons/cloud_camera.png',
              navigate: 4,
              active: widget.active == 4 ? 1 : 0,
            ),
          ],
        ),
      ),
    );
  }

  Widget buildUserPart({required String name, required String email, required String ava}){
    return ListTile(
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: Colors.black26),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 5,
              blurRadius: 7,
              offset: const Offset(0, 3), // changes position of shadow
            ),
          ],
        ),
        child: Image.asset(ava),
      ),
      title: Text(
        name,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 18,
        )
      ),
      subtitle: Text(
          email,
          style: const TextStyle(
            fontWeight: FontWeight.w400,
            fontSize: 12,
          )
      ),
      trailing: const Icon(Icons.arrow_right_outlined),
      onTap: (){
        Get.snackbar(
          'Chuồn chuồn',
          'Chuyển đến trang người dùng',
          snackPosition: SnackPosition.BOTTOM,
        );
      },
    );
  }

  Widget buildMenuItemIconImage({required String text,required String icon,
    required int navigate, required int active}) {
    const color = Colors.white;
    const _hoverColor = Color.fromRGBO(74, 116, 227, 1);
    const _default = Colors.black87;

    return Container(
      color: active == 1 ? _hoverColor : null,
      child: ListTile(
        leading: ImageIcon(AssetImage(icon), color: active == 1 ? color : _default,),
        title: Text(text,style: TextStyle(color: active == 1 ? color : _default, fontWeight: FontWeight.bold, fontSize: 16)),
        onTap: (){
          if(_isLogin == true){
            if(navigate == 0){

            }else if(navigate == 1){
              Get.to(() => const Home());
            }else if(navigate == 2){
              Get.to(() => const HourlyDetails());
            }else if(navigate == 3){
              Get.to(() => const DailyDetails());
            } else if(navigate == 4){
              Get.to(() => TakePictureScreen(camera: cameras));
            } else {
              Get.snackbar(
                "Chuồn chuồn",
                'Chuyển tiếp đến "$text"', snackPosition: SnackPosition.BOTTOM,
              );
            }
          }else{
            Get.to(() => const Login());
          }

        },

        hoverColor: _hoverColor,
      ),
    );
  }

  Widget buildDropDown({required List<Widget> menuItem}){
    return ListView.builder(
      itemCount: menuItem.length,
      itemBuilder: (context, index){
        return menuItem[index];
      },
    );
  }
}

