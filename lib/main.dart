import 'package:fitmeter/views/screens/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() async {
  await dotenv.load(fileName: ".env");
  // Wrap the App to ProviderScope for state management using riverpod
  runApp(const ProviderScope(child: FitMeterMobile()));
}

class FitMeterMobile extends StatelessWidget {
  const FitMeterMobile({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FitMeter',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const HomePage(),
    );
  }
}
