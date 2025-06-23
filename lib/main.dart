import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:laptop_harbor/userPanel/splash.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: FirebaseOptions(
      apiKey: "AIzaSyDCs7urtpr12tHfbKRWa7ctmRdQbtkW8hQ",
      authDomain: "laptopharbor-9593d.firebaseapp.com",
      projectId: "laptopharbor-9593d",
      storageBucket: "laptopharbor-9593d.firebasestorage.app",
      messagingSenderId: "303942612229",
      appId: "1:303942612229:web:c4aac70b58ff106097336c",
      measurementId: "G-YEFNPQ32K0",
    ),
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
      home: SplashScreen(),
    );
  }
}
