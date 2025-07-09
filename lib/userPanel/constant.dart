import 'package:flutter/material.dart';

class MyButton extends StatelessWidget {
  final title;
  final VoidCallback onPressed;

  const MyButton({
    super.key,
    required this.title,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            height: 50,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(50)),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.black),
              onPressed: onPressed,

              child: Text(
                title,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

const headingStyle = TextStyle(
  fontSize: 28,
  color: Colors.black,
  fontWeight: FontWeight.w500,
);
