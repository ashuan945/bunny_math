import 'package:flutter/material.dart';
import 'dart:math';
import 'package:bunny_math/widgets/gradient_background.dart';
import 'services/audio_service.dart';

class CountingScreen extends StatefulWidget {
  final int maxNumber;
  const CountingScreen({super.key, required this.maxNumber});

  @override
  _CountingScreenState createState() => _CountingScreenState();
}

class _CountingScreenState extends State<CountingScreen> with SingleTickerProviderStateMixin {
  final audioService = AudioService();

  int objectCount = 0;
  List<int> options = [];
  String feedback = '';
  String currentObjectEmoji = '🐰'; // track bunny or carrot
  List<String> objectEmojis = [];
  int? selectedAnswer;
  String? feedbackGif; // show correct.gif or wrong.gif

  late Color buttonColor;

  @override
  void initState() {
    super.initState();
    if (widget.maxNumber <= 10) {
      buttonColor = const Color.fromARGB(255, 108, 200, 108);
    } else if (widget.maxNumber <= 20) {
      buttonColor = const Color.fromARGB(255, 251, 190, 116);
    } else {
      buttonColor = const Color.fromARGB(255, 247, 130, 130);
    }
    generateQuestion();
  }

  void generateQuestion() {
    final random = Random();
    objectCount = random.nextInt(widget.maxNumber + 1);
    currentObjectEmoji = random.nextBool() ? '🐰' : '🥕';
    objectEmojis = List.generate(objectCount, (_) => currentObjectEmoji);

    Set<int> opts = {objectCount};
    while (opts.length < 3) {
      int wrong = random.nextInt(widget.maxNumber + 1);
      if (wrong != objectCount) {
        opts.add(wrong);
      }
    }

    options = opts.toList();
    options.shuffle();

    feedback = '';
    feedbackGif = null;
    selectedAnswer = null;

    setState(() {});
  }

  void checkAnswer(int answer) async {
    setState(() {
      selectedAnswer = answer;
    });

    if (answer == objectCount) {
      await audioService.playCorrectSound();
      setState(() {
        feedback = 'Correct!';
        feedbackGif = 'assets/images/correct.gif';
      });
      await Future.delayed(const Duration(milliseconds: 800));
      generateQuestion();
    } else {
      await audioService.playWrongSound();
      setState(() {
        feedback = 'Try again!';
        feedbackGif = 'assets/images/wrong.gif';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Counting',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: GradientBackground(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: IntrinsicHeight(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(height: 10),
                        Text(
                          currentObjectEmoji == '🐰' ? 'How many bunnies?' : 'How many carrots?',
                          style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 15),
                        Wrap(
                          alignment: WrapAlignment.center,
                          spacing: 8,
                          runSpacing: 8,
                          children: objectEmojis.map((e) => Text(e, style: const TextStyle(fontSize: 32))).toList(),
                        ),
                        const Spacer(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: options.map(
                            (num) {
                              bool isSelected = selectedAnswer == num;
                              return Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 8),
                                child: GestureDetector(
                                  onTap: () => checkAnswer(num),
                                  child: AnimatedContainer(
                                    duration: const Duration(milliseconds: 200),
                                    width: 80,
                                    height: 80,
                                    decoration: BoxDecoration(
                                      color: isSelected ? buttonColor.withOpacity(0.8) : buttonColor,
                                      borderRadius: BorderRadius.circular(12),
                                      boxShadow: isSelected
                                          ? [
                                              BoxShadow(
                                                color: Colors.black26,
                                                blurRadius: 8,
                                                offset: const Offset(0, 4),
                                              )
                                            ]
                                          : [],
                                    ),
                                    child: Center(
                                      child: Text(
                                        '$num',
                                        style: const TextStyle(
                                          fontSize: 24,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ).toList(),
                        ),
                        const SizedBox(height: 20),
                        if (feedbackGif != null)
                          Column(
                            children: [
                              Image.asset(
                                feedbackGif!,
                                height: 60,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                feedback,
                                style: const TextStyle(fontSize: 24, color: Colors.black),
                              ),
                            ],
                          ),
                        const SizedBox(height: 15),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
