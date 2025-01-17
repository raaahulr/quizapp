import 'package:flutter/material.dart';
import 'package:quiz_app/answer_button.dart';
import 'package:quiz_app/data/questions.dart';

class QuestionsScreen extends StatefulWidget {
  const QuestionsScreen(this.onSelectedAnswer, this.onConfirm, {super.key});

  final void Function(String answer) onSelectedAnswer;
  final void Function() onConfirm;

  @override
  State<QuestionsScreen> createState() {
    return _QuestionsScreenState();
  }
}

class _QuestionsScreenState extends State<QuestionsScreen> {
  var currentQuestionIndex = 0;
  String? selectedAnswer; // Track the selected answer

  // void anwserQuestion(String selectedAnswer) {
  //   widget.onSelectedAnswer(selectedAnswer);
  //   setState(() {
  //     currentQuestionIndex++;
  //   });
  // }
  void answerQuestion(String answer) {
    setState(() {
      selectedAnswer = answer; // Set the selected answer
    });
  }

  void nextQuestion() {
    if (selectedAnswer != null) {
      widget.onSelectedAnswer(selectedAnswer!); // Pass the selected answer
      setState(() {
        currentQuestionIndex++;
        selectedAnswer =
            null; // Reset the selected answer for the next question
      });
    }
  }

  @override
  Widget build(context) {
    final currentQuestion = questions[currentQuestionIndex];
    // final currentQuestion = questions[currentQuestionIndex];
    final isLastQuestion = currentQuestionIndex == questions.length - 1;
    return SizedBox(
      width: double.infinity,
      child: Container(
        margin: const EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              currentQuestion.text,
              style: TextStyle(
                color: const Color.fromARGB(255, 70, 4, 100),
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),
            ...currentQuestion.getShuffledAnswers().map((answers) {
              return AnswerButton(
                answers,
                () {
                  answerQuestion(answers);
                },
                isSelected: selectedAnswer == answers,
              );
            }),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: selectedAnswer ==
                      null // Enable button only if an answer is selected
                  ? null
                  : () {
                      if (isLastQuestion) {
                        widget.onConfirm(); // Call the confirm function
                      } else {
                        nextQuestion(); // Move to the next question
                      }
                    },
              child: Text(isLastQuestion ? 'Confirm' : 'Next'),
            ),
          ],
        ),
      ),
    );
  }
}
