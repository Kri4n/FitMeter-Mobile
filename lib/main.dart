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
      title: 'FitMeter Mobile',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 38, 39, 91),
      appBar: AppBar(title: const Text("Profile")),
      bottomNavigationBar: MaterialApp(),
    );
  }
}
