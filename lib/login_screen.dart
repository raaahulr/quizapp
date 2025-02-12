import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:quiz_app/registration_screen.dart';

class LoginScreen extends StatefulWidget {
  final Function(String) onLogin; // Update to accept a String argument
  const LoginScreen(this.onLogin, {Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  String? errorMessage;
  final storage = FlutterSecureStorage();

  Future<void> _performLogin() async {
    if (emailController.text.isEmpty || passwordController.text.isEmpty) {
      setState(() {
        errorMessage = 'Please enter email and password';
      });
      return;
    }

    try {
      final response = await http.post(
        Uri.parse('http://10.0.2.2/backendQuiz/public/login'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'email': emailController.text,
          'password': passwordController.text,
        }),
      );

      final responseData = json.decode(response.body);

      if (response.statusCode == 200 && responseData['status'] == 'success') {
        String token = responseData['token'];
        print("This is the token key: $token");
        await storage.write(key: 'jwt_token', value: token);
        widget.onLogin(emailController.text);
      } else {
        setState(() {
          errorMessage = responseData['message'] ?? 'Login failed';
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Network error: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Login',
                  style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 20),
                TextField(
                  controller: emailController,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(),
                    filled: true,
                    fillColor: Colors.grey[200],
                    prefixIcon: Icon(Icons.email),
                  ),
                ),
                SizedBox(height: 10),
                TextField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    border: OutlineInputBorder(),
                    filled: true,
                    fillColor: Colors.grey[200],
                    prefixIcon: Icon(Icons.lock),
                  ),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _performLogin,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(
                      horizontal: 30,
                      vertical: 15,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text('Login'),
                ),
                SizedBox(height: 10),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => RegistrationScreen(),
                      ),
                    );
                  },
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.grey,
                    foregroundColor: Colors.black,
                    padding: EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 10,
                    ), // Padding
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text('Register'),
                ),
                if (errorMessage != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Text(
                      errorMessage!,
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
