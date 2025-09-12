import 'dart:convert';

import 'package:fitmeter_mobile/data/api_routes.dart';
import 'package:fitmeter_mobile/providers/auth_provider.dart';
import 'package:fitmeter_mobile/utils/flutter_secure_storage.dart';
import 'package:fitmeter_mobile/views/screens/workouts.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

// Change StatefulWidget to ConsumerStatefulWidget for state management using riverpod
class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  bool _isUsernameEmpty = false;
  bool _isPasswordEmpty = false;
  bool _isUsernameInvalid = false;
  bool _isPasswordInvalid = false;
  bool _showPassword = true;

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

  Future<void> login(String emailValue, String passwordValue) async {
    emptyCredentialsChecker(emailValue, passwordValue);

    final url = Uri.parse(ApiRoutes.login);
    var res = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({"email": emailValue, "password": passwordValue}),
    );

    if (res.statusCode == 200) {
      final dynamic data = jsonDecode(res.body);
      final String token = data['access'];

      if (kDebugMode) {
        print("Successfully Logged In");
        print('Token: $token');
      }

      await SecureStorage.saveToken(accessToken: token);

      // Navigate to WorkoutsPage after login
      if (!mounted) return; // check if widget is still in the tree
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const WorkoutsPage()),
      );
    } else {
      if (res.statusCode == 401) {
        final message = jsonDecode(res.body);

        if (message['message'] == 'Invalid password') {
          setState(() {
            _isUsernameInvalid = false;
            _isPasswordInvalid = true;
          });
        } else if (message['message'] == 'Email not found') {
          setState(() {
            _isUsernameInvalid = true;
            _isPasswordInvalid = false;
          });
        } else {
          if (kDebugMode) {
            print("Error Logging in");
          }
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Users Credentials State
    final email = ref.watch(AuthProvider.emailProvider);
    final password = ref.watch(AuthProvider.passwordProvider);

    return Scaffold(
      backgroundColor: Colors.indigo,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              "Login",
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
                  style: TextStyle(color: Colors.white),
                  // Reads Email Value (Riverpod)
                  initialValue: email,
                  // Sets Email Value (Riverpod)
                  onChanged: (value) =>
                      ref.read(AuthProvider.emailProvider.notifier).state =
                          value,
                  decoration: InputDecoration(
                    labelText: "Email",
                    errorText: _isUsernameEmpty
                        ? "Please Enter Email"
                        : _isUsernameInvalid
                        ? "Emai not found"
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
                  style: TextStyle(color: Colors.white),
                  obscureText: _showPassword,
                  initialValue: password,
                  onChanged: (value) =>
                      ref.read(AuthProvider.passwordProvider.notifier).state =
                          value,
                  decoration: InputDecoration(
                    labelText: "Password",
                    errorText: _isPasswordEmpty
                        ? "Please Enter Password"
                        : _isPasswordInvalid
                        ? "Invalid password"
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
                final emailValue = ref.read(AuthProvider.emailProvider);
                final passwordValue = ref.read(AuthProvider.passwordProvider);

                if (kDebugMode) {
                  print("Email: $emailValue");
                  print("Password: $passwordValue");
                }

                login(emailValue, passwordValue);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black54,
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10), // round corners
                ),
              ),
              child: const Text(
                "Sign In",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
