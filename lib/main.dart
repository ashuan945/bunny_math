import 'package:flutter/material.dart';
import 'counting_level_screen.dart';
import 'number_recognition_level_screen.dart';
import 'missing_number_level_screen.dart';
import 'package:bunny_math/widgets/gradient_background.dart';
import 'services/audio_service.dart';
import 'splash_screen.dart';
import 'package:google_fonts/google_fonts.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final audioService = AudioService();
  await audioService.init();
  audioService.playBgm(); // start playing bgm
  runApp(const BunnyMathApp());
}

class BunnyMathApp extends StatelessWidget {
  const BunnyMathApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bunny',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        //Apply Google Font
        textTheme: GoogleFonts.fredokaTextTheme(),
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.black,
          titleTextStyle: GoogleFonts.fredoka(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w500,
          ),
          iconTheme: const IconThemeData(color: Colors.white),
        ),
      ),
      home: SplashScreen(),
    );
  }
}

class MainMenu extends StatelessWidget {
  const MainMenu({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset('assets/images/bunny_logo.png', height: 32),
            const SizedBox(width: 8),
            const Text(
              'Bunny Math',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 26),
            ),
            const SizedBox(width: 8),
            Image.asset('assets/images/bunny_logo.png', height: 32),
          ],
        ),
      ),
      body: GradientBackground(
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20.0,
                vertical: 30.0,
              ),
              child: Column(
                children: [
                  const Text(
                    'Choose a topic',
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.w900,
                      color: Colors.black, 
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),

                  _buildCuteTopicButton(
                    context,
                    image: 'assets/images/counting.png',
                    label: 'Counting',
                    borderColor: Colors.pinkAccent,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CountingLevelScreen(),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 25),
                  _buildCuteTopicButton(
                    context,
                    image: 'assets/images/number_recognition.png',
                    label: 'Number Recognition',
                    borderColor: Colors.orangeAccent,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => NumberRecognitionLevelScreen(),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 25),
                  _buildCuteTopicButton(
                    context,
                    image: 'assets/images/missing_number.png',
                    label: 'Missing Number',
                    borderColor: Colors.lightGreen,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MissingNumberLevelScreen(),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCuteTopicButton(
    BuildContext context, {
    required String image,
    required String label,
    required Color borderColor,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 110,
            height: 110,
            decoration: BoxDecoration(
              border: Border.all(color: borderColor, width: 3),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: borderColor.withOpacity(0.4), // soft colored shadow
                  blurRadius: 8,
                  spreadRadius: 2,
                  offset: const Offset(0, 4), // vertical shadow
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.asset(image, fit: BoxFit.cover),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            label,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}
