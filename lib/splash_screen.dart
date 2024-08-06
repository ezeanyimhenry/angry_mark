import 'dart:async';
import 'package:flutter/material.dart';
import 'package:angry_mark/main_screen.dart'; // Assuming MainMenu is the first screen

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    )..repeat(reverse: true);

    _animation = Tween<double>(begin: 0.8, end: 1.2).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.bounceInOut,
      ),
    );

    // Navigate to MainMenu after 3 seconds
    Timer(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const MainMenu()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          // Background image
          Image.asset(
            'assets/images/angry-mark-theme.jpeg',
            fit: BoxFit.cover,
          ),
          // Logo image
          Center(
            child: ScaleTransition(
              scale: _animation,
              child: Image.asset(
                'assets/images/char1.png',
                height: MediaQuery.of(context).size.height * 0.6,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
