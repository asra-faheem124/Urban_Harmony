import 'package:flutter/material.dart';

const headingStyle = TextStyle(
  fontSize: 28,
  color: Colors.black,
  fontWeight: FontWeight.w500,
);

class Admin_Heading extends StatelessWidget {
  final title;
  const Admin_Heading({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
                    title,
                    style: TextStyle(
                      fontSize: 28,
                      color: Colors.black,
                      fontWeight: FontWeight.w700,
                      
                    ),
                  );
  }
}

class User_Heading extends StatelessWidget {
  final title;
  const User_Heading({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: 28,
                      color: Colors.black,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                );
  }
}