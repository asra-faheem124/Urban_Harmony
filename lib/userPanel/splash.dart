import 'dart:async';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:laptop_harbor/Admin/admin_home.dart';
import 'package:laptop_harbor/controller/getUserData.dart';
import 'package:laptop_harbor/userPanel/Home.dart';
import 'package:laptop_harbor/userPanel/login.dart';
import 'package:laptop_harbor/userPanel/welcome.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  User? user = FirebaseAuth.instance.currentUser;
  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 3), () {
      LoggedIn(context);
    });
  }
  Future<void> LoggedIn(BuildContext context) async{
    if(user != null){
      final Getuserdatacontroller getuserdatacontroller = Get.put(Getuserdatacontroller());
      var userData = await getuserdatacontroller.getuserdata(user!.uid);
      if(userData[0]['isAdmin'] == true){
        Get.offAll(AdminHomeScreen());
      }else{
        Get.offAll(HomeScreen());
      }
    }else{
      Get.off(WelcomeScreen());
    }
  }
  Widget build(BuildContext context) {
    
    return Scaffold(
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/splash3.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset("assets/images/laptop.png"),
            SizedBox(width: 10),
            DefaultTextStyle(
              style: TextStyle(
                fontSize: 20,
                color: Colors.white,
                fontWeight: FontWeight.w700,
                fontFamily: "ProductSans",
                fontStyle: FontStyle.italic,
              ),
              child: AnimatedTextKit(
                animatedTexts: [
                  TypewriterAnimatedText(
                    'LAPTOP\nHARBOUR',
                    speed: Duration(milliseconds: 150),
                  ),
                ],
              ),
            ),
           
          ],
        ),
      ),
    );
  }
}
