import 'dart:convert';

import 'package:fitmeter_mobile/data/api_routes.dart';
import 'package:fitmeter_mobile/providers/auth_provider.dart';
import 'package:fitmeter_mobile/utils/flutter_secure_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  Future<void> login(String emailValue, String passwordValue) async {
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
      var storedToken = await SecureStorage.readToken();

      if (kDebugMode) {
        print('Stored token: $storedToken');
      }
    } else {
      if (kDebugMode) {
        print("Invalid Credentials");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
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
                  initialValue: email,
                  onChanged: (value) =>
                      ref.read(AuthProvider.emailProvider.notifier).state =
                          value,
                  decoration: InputDecoration(
                    labelText: "Email",
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
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Email is required";
                    }
                    return null;
                  },
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
                  initialValue: password,
                  onChanged: (value) =>
                      ref.read(AuthProvider.passwordProvider.notifier).state =
                          value,
                  decoration: InputDecoration(
                    labelText: "Password",
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
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Password is required";
                    } else {}
                    return null;
                  },
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
