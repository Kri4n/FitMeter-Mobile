import 'package:fitmeter_mobile/views/components/bottomnavbar.dart';
import 'package:fitmeter_mobile/views/pages/home.dart';
import 'package:fitmeter_mobile/views/pages/login.dart';
import 'package:fitmeter_mobile/views/pages/register.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:go_router/go_router.dart';

void main() async {
  await dotenv.load(fileName: ".env");
  runApp(const FitMeterMobile());
}

/// The route configuration.
final GoRouter _router = GoRouter(
  routes: <RouteBase>[
    GoRoute(
      path: '/',
      builder: (BuildContext context, GoRouterState state) {
        return const HomePage();
      },
      routes: <RouteBase>[
        GoRoute(
          path: '/login',
          builder: (BuildContext context, GoRouterState state) {
            return const LoginPage();
          },
        ),
        GoRoute(
          path: '/register',
          builder: (BuildContext context, GoRouterState state) {
            return const RegisterPage();
          },
        ),
      ],
    ),
  ],
);

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
