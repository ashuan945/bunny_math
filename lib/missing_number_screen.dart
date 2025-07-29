import 'package:flutter/material.dart';
import 'dart:math';
import 'package:bunny_math/widgets/gradient_background.dart';
import 'services/audio_service.dart';

class MissingNumberScreen extends StatefulWidget {
  final int maxNumber;
  const MissingNumberScreen({super.key, required this.maxNumber});

  @override
  _MissingNumberScreenState createState() => _MissingNumberScreenState();
}

class _MissingNumberScreenState extends State<MissingNumberScreen> {
  final audioService = AudioService();

  List<int> sequence = [];
  int missingNumber = 0;
  List<int> options = [];
  String feedback = '';
  String? feedbackGif;
  int? selectedAnswer;

  late Color buttonColor;

  @override
  void initState() {
    super.initState();

    if (widget.maxNumber <= 10) {
      buttonColor = const Color.fromARGB(255, 108, 200, 108); // green
    } else if (widget.maxNumber <= 20) {
      buttonColor = const Color.fromARGB(255, 251, 190, 116); // orange
    } else {
      buttonColor = const Color.fromARGB(255, 247, 130, 130); // red/pink
    }

    generateQuestion();
  }

  void generateQuestion() {
    final random = Random();

    int step = random.nextInt(3) + 1;
    int start = random.nextInt(widget.maxNumber ~/ 2);

    sequence = List.generate(4, (i) => start + i * step);

    int hideIndex = random.nextInt(3) + 1;
    missingNumber = sequence[hideIndex];
    sequence[hideIndex] = -1;

    Set<int> opts = {missingNumber};
    while (opts.length < 3) {
      int wrong = random.nextInt(widget.maxNumber + 1);
      if (wrong != missingNumber) {
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

    if (answer == missingNumber) {
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
          'Missing Number',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: GradientBackground(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              const SizedBox(height: 40),
              const Center(
                child: Text(
                  'Find the missing number:',
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 20),
              // Display sequence with question mark image
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: sequence.map((num) {
                  if (num == -1) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      child: Image.asset(
                        'assets/images/question_mark.png',
                        width: 45,
                        height: 45,
                      ),
                    );
                  } else {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      child: Text(
                        '$num',
                        style: const TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    );
                  }
                }).toList(),
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
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
