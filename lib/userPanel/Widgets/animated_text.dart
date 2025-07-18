import 'package:flutter/material.dart';
import 'dart:async';

class AnimatedHeadline extends StatefulWidget {
  const AnimatedHeadline({super.key});

  @override
  _AnimatedHeadlineState createState() => _AnimatedHeadlineState();
}

class _AnimatedHeadlineState extends State<AnimatedHeadline> {
  final List<String> texts = [
    'Top Rated Laptops of July',
    'Budget Friendly Picks',
    'Latest Gaming Beasts',
  ];

  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    // Change text every 2 seconds
    Timer.periodic(Duration(seconds: 3), (timer) {
      setState(() {
        _currentIndex = (_currentIndex + 1) % texts.length;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFFE0E0E0), Color(0xFFF5F5F5)], // Soft grey gradient
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 10,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Center(
          child: SizedBox(
            height: 32, // Fixed height avoids layout shifts
            child: AnimatedSwitcher(
              duration: Duration(milliseconds: 600),
              transitionBuilder: (child, animation) => FadeTransition(
                opacity: animation,
                child: child,
              ),
              child: Text(
                texts[_currentIndex],
                key: ValueKey(_currentIndex), // important!
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  shadows: [
                    Shadow(
                      blurRadius: 4,
                      color: Colors.black12,
                      offset: Offset(1, 2),
                    ),
                  ],
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
