import 'package:flutter/material.dart';
import 'dart:async';
import 'main.dart'; // to navigate to MainMenu

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _rotation;
  double titleScale = 0.0; // title scale

  @override
  void initState() {
    super.initState();

    // Start title scale animation first
    Timer(Duration(milliseconds: 100), () {
      setState(() {
        titleScale = 1.0;
      });
    });

    // Start logo rotation slightly after
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1500),
    );

    _rotation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutBack));

    Timer(Duration(milliseconds: 500), () {
      // delay to start logo
      _controller.forward();
    });

    // Navigate to MainMenu after 4 seconds
    Timer(Duration(seconds: 4), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => MainMenu()),
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose(); // always dispose controllers
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color.fromARGB(255, 89, 88, 85),
              Colors.black,
              Color.fromARGB(255, 89, 88, 85),
            ],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              RotationTransition(
                turns: _rotation,
                child: Image.asset('assets/images/bunny_logo.png', width: 200),
              ),
              const SizedBox(height: 20),
              AnimatedScale(
                scale: titleScale,
                duration: Duration(milliseconds: 2000),
                curve: Curves.easeOutBack,
                child: const Text(
                  'Bunny Math',
                  style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
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
