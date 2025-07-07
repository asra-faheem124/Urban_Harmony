import 'package:flutter/material.dart';
import 'package:laptop_harbor/userPanel/BottomBar.dart';
import 'package:laptop_harbor/userPanel/Home.dart';
import 'package:laptop_harbor/userPanel/constant.dart';
import 'package:laptop_harbor/userPanel/login.dart';
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
       color: Colors.white,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                textAlign: TextAlign.center,
                "Welcome to \n Laptop Harbour",
                style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold),
              ),
              Lottie.asset(
                'assets/videos/lottieAnimation.json', // Path to your animation file
                width: 200, // Customize size
                height: 200, // Customize size
                fit: BoxFit.fill, // Animation fit style
              ),
              Text(
                textAlign: TextAlign.center,
                "Your Trusted Dock for the \n Perfect Laptop",
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              SizedBox(
                width: 400,
                child: Text(
                  "Find your ideal machine from top brands, compare features with ease, and shop smart—all in one seamless experience.",
                  style: TextStyle(fontSize: 15),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(height: 20),
              MyButton(title: "Explore", route: BottomBar()),
            ],
          ),
        ),
      ),
    );
  }
}
