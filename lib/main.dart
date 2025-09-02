import 'package:fitmeter_mobile/views/components/bottomnavbar.dart';
// import 'package:fitmeter_mobile/views/pages/home.dart';
// import 'package:fitmeter_mobile/views/pages/login.dart';
// import 'package:fitmeter_mobile/views/pages/register.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:go_router/go_router.dart';

final emailProvider = StateProvider<String>((ref) => '');
final passwordProvider = StateProvider<String>((ref) => '');
final tokenProvider = StateProvider<String>((ref) => '');

void main() async {
  await dotenv.load(fileName: ".env");
  runApp(const ProviderScope(child: FitMeterMobile()));
}

class FitMeterMobile extends StatelessWidget {
  const FitMeterMobile({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FitMeter',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const BottomNavBar(),
    );
  }
}
