import 'package:flutter/material.dart';

class StartScreen extends StatelessWidget {
  const StartScreen(this.startQuiz, {super.key});

  final void Function() startQuiz;

  @override
  Widget build(context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(
            'assets/images/quiz-logo.png',
            width: 300,
            color: const Color.fromARGB(130, 242, 238, 238),
          ),
          const SizedBox(height: 30),
          const Text(
            'Learn flutter in fun ways',
            style: TextStyle(
              color: Color.fromARGB(255, 70, 4, 100),
              fontSize: 24,
            ),
          ),
          const SizedBox(height: 20),
          OutlinedButton.icon(
            onPressed: startQuiz,
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.white,
            ),
            icon: Icon(Icons.arrow_right_alt),
            label: const Text(
              'start quiz',
              style: TextStyle(fontSize: 15),
            ),
          )
        ],
      ),
    );
  }
}
