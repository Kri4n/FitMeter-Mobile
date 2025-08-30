import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  await dotenv.load(fileName: ".env");
  runApp(const FitMeterMobile());
}

class FitMeterMobile extends StatelessWidget {
  const FitMeterMobile({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FitMeter',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: Scaffold(
        backgroundColor: Colors.indigo,
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset('assets/fitmeter-logo.png', width: 150, height: 150),
              const Text(
                "Welcome to FitMeter",
                style: TextStyle(color: Colors.white, fontSize: 30),
              ),
              SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                ), // left & right space
                child: const Text(
                  "Track your fitness journey, set goals, and stay motivated every day!",
                  style: TextStyle(color: Colors.white, fontSize: 14),
                  textAlign: TextAlign.center, // keep it centered
                ),
              ),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  if (kDebugMode) {
                    print('Navigate to register page');
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.lightBlue,
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10), // round corners
                  ),
                ),
                child: const Text(
                  "Get Started",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
        appBar: AppBar(
          backgroundColor: Colors.black87,
          title: const Text("FitMeter", style: TextStyle(color: Colors.white)),
        ),
        bottomNavigationBar: BottomNavigationBar(
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
            BottomNavigationBarItem(icon: Icon(Icons.login), label: 'Login'),
            BottomNavigationBarItem(
              icon: Icon(Icons.app_registration_rounded),
              label: 'Register',
            ),
          ],
        ),
      ),
    );
  }
}
