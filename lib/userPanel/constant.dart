import 'package:flutter/material.dart';

class MyButton extends StatelessWidget {
  final title;
  final route;
  const MyButton({super.key, required this.title, required this.route});

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
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context){
                return route;
                }));
              },
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

