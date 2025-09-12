import 'dart:convert';

import 'package:fitmeter/data/api_routes.dart';
import 'package:fitmeter/views/screens/login.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  bool _isUsernameEmpty = false;
  bool _isPasswordEmpty = false;
  bool _isUsernameInvalid = false;
  bool _isPasswordInvalid = false;
  bool _showPassword = true;

  // Credentials to be registered
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();

  @override
  void dispose() {
    _email.dispose();
    super.dispose();
  }

  Future<void> emptyCredentialsChecker(
    String emailValue,
    String passwordValue,
  ) async {
    if (emailValue == "") {
      setState(() {
        _isUsernameEmpty = true;
      });
    } else {
      _isUsernameEmpty = false;
    }
    if (passwordValue == "") {
      setState(() {
        _isPasswordEmpty = true;
      });
    } else {
      _isPasswordEmpty = false;
    }
  }

  Future<void> register(String emailValue, String passwordValue) async {
    emptyCredentialsChecker(emailValue, passwordValue);

    final url = Uri.parse(ApiRoutes.register);
    try {
      final res = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': emailValue, 'password': passwordValue}),
      );

      if (res.statusCode == 201) {
        if (kDebugMode) {
          print(res.body);
        }
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Successfully Registered'),
            backgroundColor: Colors.green, // optional
          ),
        );

        if (!mounted) return;
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const LoginPage()),
        );
      } else if (res.statusCode == 400) {
        final error = jsonDecode(res.body);
        if (kDebugMode) {
          print(error);
        }

        switch (error['message']) {
          case "Invalid email format. Please include @":
            setState(() {
              _isUsernameInvalid = true;
              _isPasswordInvalid = false;
            });

          case "Password must be at least 8 characters long":
            setState(() {
              _isUsernameInvalid = false;
              _isPasswordInvalid = true;
            });
        }
      } else {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Register Failed, Something Went Wrong'),
            backgroundColor: Colors.red, // optional
          ),
        );
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error $e");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.indigo,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              "Register",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 30,
              ),
            ),
            SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 24,
              ), // left & right space
              child: Form(
                child: TextFormField(
                  controller: _email,
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    labelText: "Email",
                    errorText: _isUsernameEmpty
                        ? "Please Enter Email"
                        : _isUsernameInvalid
                        ? "Invalid email format. Please include @"
                        : null,
                    labelStyle: TextStyle(color: Colors.white),
                    hintText: "Enter your email",
                    hintStyle: TextStyle(color: Colors.white),
                    border: OutlineInputBorder(),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white, width: 2),
                    ),
                    prefixIcon: Icon(Icons.email, color: Colors.white),
                  ),
                  cursorColor: Colors.white,
                ),
              ),
            ),
            SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 24,
              ), // left & right space
              child: Form(
                child: TextFormField(
                  controller: _password,
                  obscureText: _showPassword,
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    labelText: "Password",
                    errorText: _isPasswordEmpty
                        ? "Please Enter Password"
                        : _isPasswordInvalid
                        ? "Password must be 8 characters long"
                        : null,
                    labelStyle: TextStyle(color: Colors.white),
                    hintText: "Enter your password",
                    hintStyle: TextStyle(color: Colors.white),
                    border: OutlineInputBorder(),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white, width: 2),
                    ),
                    prefixIcon: Icon(Icons.password, color: Colors.white),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _showPassword ? Icons.visibility_off : Icons.visibility,
                      ),
                      color: Colors.white,
                      onPressed: () {
                        setState(() {
                          _showPassword = !_showPassword;
                        });
                      },
                    ),
                  ),
                  cursorColor: Colors.white,
                ),
              ),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                final String emailValue = _email.text;
                final String passwordValue = _password.text;

                if (kDebugMode) {
                  print(emailValue);
                  print(passwordValue);
                }

                register(emailValue, passwordValue);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF111827),
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10), // round corners
                ),
              ),
              child: const Text(
                "Create Account",
                style: TextStyle(color: Colors.white),
              ),
            ),
            SizedBox(height: 10),
            InkWell(
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginPage()),
                );
              },
              child: const Text(
                "Sign In",
                style: TextStyle(
                  color: Color(0xFF111827),
                  fontWeight: FontWeight.bold,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
