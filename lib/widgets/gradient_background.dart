
import 'package:flutter/material.dart';

class GradientBackground extends StatelessWidget {
  final Widget child;
  const GradientBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color.fromARGB(255, 253, 250, 168), // top color
            Color.fromARGB(255, 255, 254, 227), // middle color
            Color.fromARGB(177, 255, 254, 227), // middle color
            Color.fromARGB(255, 225, 255, 185), // bottom color
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: child,
    );
  }
}
