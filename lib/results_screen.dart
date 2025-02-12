import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:quiz_app/data/questions.dart';
import 'package:quiz_app/login_screen.dart';
import 'package:quiz_app/questions_summary.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ResultsScreen extends StatelessWidget {
  const ResultsScreen(this.chosenAnswer, this.onRestart, this.email,
      {super.key});

  final List<String> chosenAnswer;
  final void Function() onRestart;
  final String email;

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

  Future<void> saveQuizResult(
      int correctAnswers, int totalQuestions, BuildContext context) async {
    final url = 'http://10.0.2.2/backendQuiz/public/saveResult';
    final storage = FlutterSecureStorage();
    final token = await storage.read(key: 'jwt_token'); // Retrieve the token

    if (token == null) {
      print('No token found');
      return;
    }

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': token,
        },
        body: json.encode({
          'email': email,
          'correct_answers': correctAnswers,
          'total_questions': totalQuestions,
        }),
      );

      final responseData = json.decode(response.body);

      if (response.statusCode == 200 && responseData['status'] == 'success') {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Quiz result saved successfully!'),
            backgroundColor: Colors.green,
          ),
        );
      } else if (responseData['message'] == 'Token expired') {
        // Token expired case, prompt the user to log in again
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Your session has expired. Please log in again.'),
            backgroundColor: Colors.red,
          ),
        );

        // Switch back to the login screen for re-authentication
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => LoginScreen((email) {
              // Re-login logic here
              saveQuizResult(correctAnswers, totalQuestions,
                  context); // Retry saving result after re-login
            }),
          ),
          (route) => false,
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                'Failed to save quiz result: ${responseData['message'] ?? 'Unknown error'}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error saving quiz result: $e'),
          backgroundColor: Colors.red,
        ),
      );
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
          numCorrectQuestions, numTotalQuestions, context); // Store email here
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
