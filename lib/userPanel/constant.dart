//button
import 'package:flutter/material.dart';

class ButtonForm extends StatelessWidget {
  final title;
  const ButtonForm({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 130,
      height: 50,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(50)),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(backgroundColor: Colors.black),
        onPressed: () {},
        child: Text(
          title,
          style: TextStyle(
            color: Colors.white,
            fontFamily: 'ProductSans-b',
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}
