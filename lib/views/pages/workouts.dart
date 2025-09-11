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
  List<dynamic> _workouts = [];

  bool isLoading = false;

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

  Future<void> fetchWorkouts() async {
    var token = await SecureStorage.readToken();
    setState(() {
      isLoading = true;
    });
    final url = Uri.parse(ApiRoutes.getWorkouts);

    final res = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (res.statusCode == 200) {
      if (kDebugMode) {
        print(res.body);
      }
      final data = jsonDecode(res.body);
      if (kDebugMode) {
        print(data);
      }
      setState(() {
        _workouts = data;
      });
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> deleteWorkout(String workoutId) async {
    var token = await SecureStorage.readToken();
    final url = ApiRoutes.deleteWorkout(workoutId);
    final res = await http.delete(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (res.statusCode == 200) {
      final message = jsonDecode(res.body);
      if (kDebugMode) {
        print(message);
      }
    } else {
      if (kDebugMode) {
        print("Failed to delete workout");
      }
    }

    fetchWorkouts();
  }

  Future<void> updateWorkout(String workoutId) async {
    var token = await SecureStorage.readToken();
    final workoutName = Workouts.name;
    final duration = Workouts.duration;

    final url = ApiRoutes.updateWorkout(workoutId);
    final res = await http.patch(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({'name': workoutName, 'duration': duration}),
    );

    if (res.statusCode == 200) {
      final data = jsonDecode(res.body);
      if (kDebugMode) {
        print(data['message']);
      }
    } else {
      if (kDebugMode) {
        print("Failed to update workout");
      }
    }

    fetchWorkouts();
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

  Future<void> updateWorkoutForm(String workoutId) async {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Update Workout"),
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
                ),
                TextFormField(
                  initialValue: Workouts.duration,
                  onChanged: (value) => setState(() {
                    Workouts.duration = value;
                  }),
                  decoration: const InputDecoration(labelText: "Duration"),
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
                if (!mounted) return;
                Navigator.pop(context);
                // handle form submission
                updateWorkout(workoutId);
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

    fetchWorkouts();
  }

  @override
  void initState() {
    super.initState();
    readToken();
    fetchWorkouts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'FitMeter',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFF111827),
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
      body: isLoading
          ? Center(child: CircularProgressIndicator(color: Colors.white))
          : _workouts.isEmpty
          ? const Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('No Workouts', style: TextStyle(color: Colors.white)),
                ],
              ),
            )
          : Center(
              child: ListView.builder(
                padding: const EdgeInsets.only(top: 6),
                itemCount: _workouts.length,
                itemBuilder: (context, index) {
                  final workout = _workouts[index];
                  return Card(
                    color: const Color(0xFF111827),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    margin: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 5,
                    ),
                    child: ListTile(
                      title: Text(
                        workout["name"],
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                      subtitle: Text(
                        "Duration: ${workout["duration"]}\nStatus: ${workout["status"]}",
                        style: const TextStyle(color: Colors.white70),
                      ),
                      trailing: PopupMenuButton<String>(
                        icon: const Icon(Icons.more_vert, color: Colors.white),
                        onSelected: (value) async {
                          switch (value) {
                            case 'update':
                              final workoutId = workout["_id"];
                              updateWorkoutForm(workoutId);
                            case 'delete':
                              final workoutId = workout["_id"];
                              deleteWorkout(workoutId);
                          }
                        },
                        itemBuilder: (BuildContext context) => [
                          const PopupMenuItem(
                            value: 'update',
                            child: Text('Update'),
                          ),
                          const PopupMenuItem(
                            value: 'delete',
                            child: Text('Delete'),
                          ),
                        ],
                      ),
                    ),
                  );
                },
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
