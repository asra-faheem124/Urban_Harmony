import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:laptop_harbor/userPanel/BottomBar.dart';
import 'package:laptop_harbor/userPanel/Widgets/button.dart';
import 'package:lottie/lottie.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
@override
Widget build(BuildContext context) {
  return Scaffold(
    body: Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.white, const Color.fromARGB(255, 136, 136, 136)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Welcome to \n Laptop Harbour",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Lottie.asset(
              'assets/videos/lottieAnimation.json',
              width: 300,
              height: 300,
              fit: BoxFit.fill,
            ),
            SizedBox(height: 20),
            Text(
              "Your Trusted Dock for the \n Perfect Laptop",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            SizedBox(
              width: 370,
              child: Text(
                "Find your ideal machine from top brands, compare features with ease, and shop smart—all in one seamless experience.",
                style: TextStyle(fontSize: 15),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: 20),
            MyButton(
              title: 'Explore',
              height: 50.0,
              onPressed: () => Get.offAll(BottomBar()),
            ),
          ],
        ),
      ),
    ),
  );
}
}
