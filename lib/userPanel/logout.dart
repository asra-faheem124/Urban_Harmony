import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:laptop_harbor/userPanel/login.dart';
import 'package:laptop_harbor/userPanel/signup.dart';

class Logout extends StatelessWidget {
  const Logout({super.key});
  void _logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    // Navigate to login screen after logout
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context){
      return SignUp();
    }));
  }

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}