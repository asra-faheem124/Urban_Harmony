import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:laptop_harbor/userPanel/Home.dart';
import 'package:laptop_harbor/userPanel/Profile.dart';
import 'package:laptop_harbor/userPanel/create_new_password.dart';
import 'package:laptop_harbor/userPanel/login.dart';
import 'package:laptop_harbor/userPanel/rate_us.dart';
import 'package:laptop_harbor/userPanel/splash.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      theme: ThemeData(fontFamily: 'ProductSans'),
      debugShowCheckedModeBanner: false,
      home: CreateNewPassword(),
    );
  }
}
