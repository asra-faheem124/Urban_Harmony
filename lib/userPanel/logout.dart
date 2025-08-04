import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:laptop_harbor/userPanel/BottomBar.dart';
import 'package:laptop_harbor/userPanel/Widgets/SnackBar.dart';
import 'package:laptop_harbor/userPanel/Widgets/button.dart';
import 'package:lottie/lottie.dart';

class LogoutScreen extends StatelessWidget {
  const LogoutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(backgroundColor: Colors.white),

      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Lottie.asset(
            'assets/videos/lottieAnimation2.json', // Path to your animation file
            width: 300, // Customize size
            height: 300, // Customize size
            fit: BoxFit.fill, // Animation fit style
          ),
          Text(
            "Log Out",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 40),
          ),
          Text(
            "Logging out will end your current session, you can always log back in anytime to access your account",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 18),
          ),
          SizedBox(height: 10),
          MyButton(
            title: "Logout",
            height: 50.0,
            onPressed: () {
              FirebaseAuth _auth = FirebaseAuth.instance;
              _auth.signOut();
              greenSnackBar(
                '✅ Success!',
                'Logout Successful! You have been logged out.',
              );
              Get.offAll(BottomBar());
            },
          ),
        ],
      ),
    );
  }
}
