import 'package:flutter/material.dart';
import 'package:quiz_app/data/questions.dart';
import 'package:quiz_app/questions_screen.dart';
import 'package:quiz_app/results_screen.dart';
import 'package:quiz_app/start_screen.dart';
import 'package:quiz_app/login_screen.dart';
import 'package:quiz_app/registration_screen.dart';

class Quiz extends StatefulWidget {
  const Quiz({super.key});

  @override
  State<Quiz> createState() {
    return _QuizState();
  }
}

class _QuizState extends State<Quiz> {
  List<String> selectedAnswers = [];
  var activeScreen = 'login-screen'; // Start with the login screen

  void switchScreen() {
    setState(() {
      activeScreen = 'questions-screen';
    });
  }

  void restartQuiz() {
    setState(() {
      selectedAnswers = [];
      activeScreen = 'questions-screen';
    });
  }

  void chooseAnswer(String answer) {
    selectedAnswers.add(answer);

    if (selectedAnswers.length == questions.length) {
      setState(() {
        activeScreen = 'results-screen';
      });
    }
  }

  void confirmAnswers() {
    setState(() {
      activeScreen = 'results-screen';
    });
  }

  void login() {
    setState(() {
      activeScreen = 'start-screen'; // Switch to start screen after login
    });
  }

  void startQuiz() {
    setState(() {
      activeScreen = 'questions-screen'; // Logic to start the quiz
    });
  }

  @override
  Widget build(BuildContext context) {
    // Initialize screenWidget with a default value
    Widget screenWidget;

    // Determine which screen to display based on activeScreen
    if (activeScreen == 'login-screen') {
      screenWidget = LoginScreen(login);
    } else if (activeScreen == 'registration-screen') {
      screenWidget = RegistrationScreen();
    } else if (activeScreen == 'questions-screen') {
      screenWidget = QuestionsScreen(chooseAnswer, confirmAnswers);
    } else if (activeScreen == 'results-screen') {
      screenWidget = ResultsScreen(selectedAnswers, restartQuiz);
    } else {
      // Fallback to the login screen if none match
      screenWidget = StartScreen(startQuiz);
    }

    return MaterialApp(
      home: Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.deepPurple,
                Color.fromARGB(255, 58, 183, 125),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: screenWidget,
        ),
      ),
    );
  }
}
