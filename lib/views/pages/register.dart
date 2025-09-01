import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  static const tabs = ['/', '/login', '/register'];

  @override
  Widget build(BuildContext context) {
    final String location = GoRouterState.of(context).uri.toString();

    int selectedIndex = tabs.indexWhere((tab) => location.startsWith(tab));
    if (selectedIndex == -1) selectedIndex = 0;

    return Scaffold(
      backgroundColor: Colors.indigo,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              "Register",
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
              onPressed: () {},
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
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: selectedIndex,
        onTap: (index) {
          context.go(tabs[index]); // navigate using go_router
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.login), label: 'Login'),
          BottomNavigationBarItem(
            icon: Icon(Icons.app_registration_rounded),
            label: 'Register',
          ),
        ],
      ),
    );
  }
}
