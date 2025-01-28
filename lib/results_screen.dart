import 'package:flutter/material.dart';
import 'package:quiz_app/data/questions.dart';
import 'package:quiz_app/questions_summary.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ResultsScreen extends StatelessWidget {
  const ResultsScreen(this.chosenAnswer, this.onRestart, this.email,
      {super.key});

  final List<String> chosenAnswer;
  final void Function() onRestart;
  final String email; // Accept email as a parameter

  List<Map<String, Object>> getSummaryData() {
    final List<Map<String, Object>> summary = [];

    for (var i = 0; i < chosenAnswer.length; i++) {
      summary.add(
        {
          'question_index': i,
          'question': questions[i].text,
          'correct_answer': questions[i].answer[0],
          'user_answer': chosenAnswer[i],
        },
      );
    }

    return summary;
  }

  Future<void> saveQuizResult(int correctAnswers, int totalQuestions) async {
    final url =
        'http://10.0.2.2/backendQuiz/public/saveResult'; // Update with your API URL

    try {
      final response = await http.post(Uri.parse(url),
          headers: {'Content-Type': 'application/json'},
          body: json.encode({
            'email': email, // Use the email parameter
            'correct_answers': correctAnswers,
            'total_questions': totalQuestions
          }));

      print('Response Status Code: ${response.statusCode}'); // Log status code
      print('Response Body: ${response.body}'); // Log response body

      if (response.statusCode == 200) {
        print('Quiz result saved successfully');
      } else {
        print('Failed to save quiz result: ${response.body}');
      }
    } catch (e) {
      print('Error saving quiz result: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final summaryData = getSummaryData();
    final numTotalQuestions = questions.length;
    final numCorrectQuestions = summaryData.where((data) {
      return data['user_answer'] == data['correct_answer'];
    }).length;

    // Save result when screen is shown
    WidgetsBinding.instance.addPostFrameCallback((_) {
      saveQuizResult(
          numCorrectQuestions, numTotalQuestions); // Store email here
    });

    return SizedBox(
      width: double.infinity,
      child: Container(
        margin: const EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'You answered $numCorrectQuestions out $numTotalQuestions questions correctly!',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(
              height: 30,
            ),
            QuestionsSummary(getSummaryData()),
            const SizedBox(
              height: 30,
            ),
            TextButton(
              onPressed: onRestart,
              child: const Text(
                '🔄️Restart Quiz!',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
