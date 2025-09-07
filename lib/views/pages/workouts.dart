import 'package:fitmeter_mobile/utils/flutter_secure_storage.dart';
import 'package:fitmeter_mobile/views/components/bottomnavbar.dart';
import 'package:fitmeter_mobile/views/components/showyesnodialog.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class WorkoutsPage extends StatefulWidget {
  const WorkoutsPage({super.key});

  @override
  State<WorkoutsPage> createState() => _WorkoutsPageState();
}

class _WorkoutsPageState extends State<WorkoutsPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _workout = TextEditingController();
  final TextEditingController _duration = TextEditingController();

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
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min, // prevents full-screen height
              children: [
                TextFormField(
                  controller: _workout,
                  decoration: const InputDecoration(labelText: "Name"),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter your workout";
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _duration,
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
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  // handle form submission
                  Navigator.pop(context); // close dialog
                }
              },
              child: const Text("Submit"),
            ),
          ],
        );
      },
    );
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
