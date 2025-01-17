import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:quiz_app/quiz.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    await Firebase.initializeApp(
        options: FirebaseOptions(
            apiKey: "AIzaSyDcHLhdze6TAbx-rVy6p3NM5ppTQcVzLHE",
            appId: "1:451268846488:web:2920b9929fc41caf6741ed",
            messagingSenderId: "451268846488",
            projectId: "quizapptrail"));
  }
  await Firebase.initializeApp();
  runApp(Quiz());
}
