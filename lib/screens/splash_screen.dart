import 'package:flutter/material.dart';
import 'dart:async'; // For Timer

import 'donarhome_screen.dart';
import 'signin_screen.dart'; // Import your DonarHomeScreen

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _logoAnimation;
  late Animation<double> _textAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2),
    );

    _logoAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeOut,
      ),
    );

    _textAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Interval(0.5, 1, curve: Curves.easeOut),
      ),
    );

    _animationController.forward();

    Timer(
      Duration(seconds: 3), // Adjust duration as needed
      () => Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => SignInScreen()),
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.orange.shade300, Colors.orange.shade800],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              FadeTransition(
                opacity: _logoAnimation,
                child: ScaleTransition(
                  scale: _logoAnimation,
                  child: Image.asset(
                    'assets/images/WEicon.png', // Replace with your logo asset path
                    width: 150, // Adjust size as needed
                  ),
                ),
              ),
              SizedBox(height: 20),
              FadeTransition(
                opacity: _textAnimation,
                child: Text(
                  'WeFeed',
                  style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              SizedBox(height: 10),
              FadeTransition(
                opacity: _textAnimation,
                child: Text(
                  'Food Donation Application',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white70,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
