import 'package:fitmeter_mobile/utils/flutter_secure_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class WorkoutsPage extends StatefulWidget {
  const WorkoutsPage({super.key});

  @override
  State<WorkoutsPage> createState() => _WorkoutsPageState();
}

class _WorkoutsPageState extends State<WorkoutsPage> {
  Future<void> readToken() async {
    var storedToken = await SecureStorage.readToken();
    if (storedToken == null) {
      if (kDebugMode) {
        print("Token Session Expired, Please login");
      }
    }
    if (kDebugMode) {
      print("Stored Token: $storedToken");
    }
  }

  @override
  void initState() {
    super.initState();
    readToken();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('FitMeter', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.blueAccent,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            onPressed: () {
              // Add your logout logic here
              print("Logout pressed");
            },
          ),
        ],
      ),
      backgroundColor: Colors.indigo,
      body: const Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Workouts Page', style: TextStyle(color: Colors.white)),
          ],
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 20),
        child: FloatingActionButton(
          onPressed: () {
            if (kDebugMode) {
              print("Add Workout");
            }
          },
          backgroundColor: Colors.blueAccent,
          shape: const CircleBorder(),
          child: const Icon(Icons.add, size: 30, color: Colors.white),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
