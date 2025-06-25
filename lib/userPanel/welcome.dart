import 'package:flutter/material.dart';
import 'package:laptop_harbor/userPanel/login.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:Column(
        children: [
           Text('Welcome to Laptop Harbor'),
           ElevatedButton(onPressed: (){
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context){
              return Login();
            }));
           }, child: Text('Get Started'))
        ],
      ),
    );
  }
}