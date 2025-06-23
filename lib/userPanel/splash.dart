import 'dart:async';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:laptop_harbor/userPanel/login.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) {
            return Login();
          },
        ),
      );
    });
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
