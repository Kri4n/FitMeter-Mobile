import 'dart:convert';

import 'package:fitmeter_mobile/data/api_routes.dart';
import 'package:fitmeter_mobile/data/workouts.dart';
import 'package:fitmeter_mobile/utils/flutter_secure_storage.dart';
import 'package:fitmeter_mobile/views/components/bottomnavbar.dart';
import 'package:fitmeter_mobile/views/components/showyesnodialog.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

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

  Future<void> _addNewWorkoutForm() async {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Add new workout"),
          content: Form(
            child: Column(
              mainAxisSize: MainAxisSize.min, // prevents full-screen height
              children: [
                TextFormField(
                  initialValue: Workouts.name,
                  onChanged: (value) => setState(() {
                    Workouts.name = value;
                  }),
                  decoration: const InputDecoration(labelText: "Name"),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter your workout";
                    }
                    return null;
                  },
                ),
                TextFormField(
                  initialValue: Workouts.duration,
                  onChanged: (value) => setState(() {
                    Workouts.duration = value;
                  }),
                  decoration: const InputDecoration(labelText: "Duration"),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter duration";
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context), // close dialog
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () async {
                // handle form submission
                submitAddWorkoutForm();
              },
              child: const Text("Submit"),
            ),
          ],
        );
      },
    );
  }

  Future<void> submitAddWorkoutForm() async {
    var token = await SecureStorage.readToken();

    final workoutName = Workouts.name;
    final duration = Workouts.duration;

    if (kDebugMode) {
      print('Token: $token');
      print(workoutName);
      print(duration);
    }
    final url = Uri.parse(ApiRoutes.addWorkout);

    final res = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({'name': workoutName, 'duration': duration}),
    );

    if (res.statusCode == 201) {
      if (kDebugMode) {
        print('Workout Added Successfully!');
        print(res.body);
      }
    }

    if (!mounted) return;
    Navigator.pop(context);
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
        title: const Text(
          'FitMeter',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.blueAccent,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            onPressed: () async {
              // Add your logout logic here
              if (kDebugMode) {
                print("Logout pressed");
              }

              final result = await showYesNoDialog(
                context: context,
                title: "Logout",
                message: "Are you sure you want to logout?",
                yesLabel: "Yes",
                noLabel: "No",
              );

              if (result == true) {
                await SecureStorage.deleteToken();

                if (!mounted) return;
                Navigator.pushReplacement(
                  // ignore: use_build_context_synchronously
                  context,
                  MaterialPageRoute(builder: (context) => const BottomNavBar()),
                );
              } else {
                if (kDebugMode) {
                  print('Cancel');
                }
              }
            },
          ),
        ],
      ),
      backgroundColor: Colors.indigo,
      body: const Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('No Workouts', style: TextStyle(color: Colors.white)),
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
            _addNewWorkoutForm();
          },
          backgroundColor: Colors.white,
          shape: const CircleBorder(),
          child: const Icon(Icons.add, size: 30, color: Colors.blueAccent),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
