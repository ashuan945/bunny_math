import 'package:flutter/material.dart';
import 'missing_number_screen.dart';
import 'package:bunny_math/widgets/gradient_background.dart';

class MissingNumberLevelScreen extends StatelessWidget {
  const MissingNumberLevelScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Missing Number',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: GradientBackground(
        child: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: screenHeight),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 10),
                  Image.asset(
                    'assets/images/bunny.gif',
                    height: 120,
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Choose your level',
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 40),
                  _buildLevelButton(
                    context,
                    color: Colors.lightGreenAccent.shade100,
                    borderColor: Colors.green,
                    emoji: '🥕',
                    label: 'Easy (0–10)',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MissingNumberScreen(maxNumber: 10),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 20),
                  _buildLevelButton(
                    context,
                    color: Colors.orangeAccent.shade100,
                    borderColor: Colors.deepOrange,
                    emoji: '🐇',
                    label: 'Medium (0–20)',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MissingNumberScreen(maxNumber: 20),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 20),
                  _buildLevelButton(
                    context,
                    color: Colors.redAccent.shade100,
                    borderColor: Colors.red,
                    emoji: '🐰',
                    label: 'Hard (0–30)',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MissingNumberScreen(maxNumber: 30),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 20), // extra bottom space
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLevelButton(
    BuildContext context, {
    required Color color,
    required Color borderColor,
    required String emoji,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        width: double.infinity,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: borderColor, width: 3),
          boxShadow: [
            BoxShadow(
              color: borderColor.withOpacity(0.4),
              blurRadius: 6,
              spreadRadius: 2,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              emoji,
              style: const TextStyle(fontSize: 26),
            ),
            const SizedBox(width: 12),
            Text(
              label,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
