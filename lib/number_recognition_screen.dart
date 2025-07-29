import 'package:flutter/material.dart';
import 'dart:math';
import 'package:bunny_math/widgets/gradient_background.dart';
import 'services/audio_service.dart';

class NumberRecognitionScreen extends StatefulWidget {
  final int maxNumber;
  const NumberRecognitionScreen({super.key, required this.maxNumber});

  @override
  _NumberRecognitionScreenState createState() => _NumberRecognitionScreenState();
}

class _NumberRecognitionScreenState extends State<NumberRecognitionScreen> {
  final audioService = AudioService();

  int number = 0;
  List<String> options = [];
  String feedback = '';
  String? feedbackGif;
  String? selectedAnswer;

  late Color buttonColor;

  final Map<int, String> numberWords = {
    0: "zero", 1: "one", 2: "two", 3: "three", 4: "four",
    5: "five", 6: "six", 7: "seven", 8: "eight", 9: "nine",
    10: "ten", 11: "eleven", 12: "twelve", 13: "thirteen",
    14: "fourteen", 15: "fifteen", 16: "sixteen", 17: "seventeen",
    18: "eighteen", 19: "nineteen", 20: "twenty",
    21: "twenty-one", 22: "twenty-two", 23: "twenty-three",
    24: "twenty-four", 25: "twenty-five", 26: "twenty-six",
    27: "twenty-seven", 28: "twenty-eight", 29: "twenty-nine",
    30: "thirty"
  };

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
    number = random.nextInt(widget.maxNumber + 1);

    Set<String> opts = {numberWords[number]!};
    while (opts.length < 3) {
      int wrong = random.nextInt(widget.maxNumber + 1);
      opts.add(numberWords[wrong]!);
    }

    options = opts.toList();
    options.shuffle();
    feedback = '';
    feedbackGif = null;
    selectedAnswer = null;

    setState(() {});
  }

  void checkAnswer(String answer) async {
    setState(() {
      selectedAnswer = answer;
    });

    if (answer == numberWords[number]) {
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
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Number Recognition',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: GradientBackground(
        child: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: screenHeight),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  const SizedBox(height: 10),
                  const Text(
                    'What is this number?',
                    style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 15),
                  Text(
                    '$number',
                    style: const TextStyle(fontSize: 80, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 15),
                  ...options.map((word) {
                    bool isSelected = selectedAnswer == word;
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      child: GestureDetector(
                        onTap: () => checkAnswer(word),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          width: double.infinity,
                          height: 60,
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
                              word,
                              style: const TextStyle(
                                fontSize: 22,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
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
        ),
      ),
    );
  }
}
