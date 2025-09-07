import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:laptop_harbor/Admin/admin_home.dart';
import 'package:laptop_harbor/DesignerPanel/Designer_home.dart';
import 'package:laptop_harbor/controller/getUserData.dart';
import 'package:laptop_harbor/userPanel/BottomBar.dart';
import 'package:laptop_harbor/userPanel/welcome.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  User? user = FirebaseAuth.instance.currentUser;
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    // Animation Controller
    _controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 2));

    // Scale Animation
    _scaleAnimation =
        Tween<double>(begin: 0.7, end: 1.2).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutBack,
    ));

    // Fade Animation
    _fadeAnimation =
        Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeIn,
    ));

    _controller.forward();

    Timer(const Duration(seconds: 3), () {
      LoggedIn(context);
    });
  }

  Future<void> LoggedIn(BuildContext context) async {
    if (user != null) {
      final Getuserdatacontroller getuserdatacontroller =
          Get.put(Getuserdatacontroller());
      var userData = await getuserdatacontroller.getuserdata(user!.uid);
      if (userData.isNotEmpty && userData[0]['isAdmin'] == true) {
        Get.offAll(const AdminHomeScreen());
      } 
      else {
        Get.offAll(const BottomBar());
      }
    } else {
      Get.off(const WelcomeScreen());
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black.withOpacity(0.1), 
      body: Center(
        child: ScaleTransition(
          scale: _scaleAnimation,
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: Image.asset(
              "assets/images/Logo1.png",
              height: 140,
            ),
          ),
        ),
      ),
    );
  }
}
