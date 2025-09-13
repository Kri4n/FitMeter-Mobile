import 'dart:async';
import 'package:flutter/material.dart';
import 'package:fitmeter/model/workouts_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class StartWorkoutPage extends ConsumerStatefulWidget {
  final WorkoutsModel workout;

  const StartWorkoutPage({super.key, required this.workout});

  @override
  ConsumerState<StartWorkoutPage> createState() => _StartWorkoutPageState();
}

class _StartWorkoutPageState extends ConsumerState<StartWorkoutPage> {
  int _countdownIndex = 0;
  Timer? _timer;
  bool _showWorkout = false;
  final List<String> _messages = ["Ready", "Set", "Go!"];

  @override
  void initState() {
    super.initState();
    _startCountdown();
  }

  void _startCountdown() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_countdownIndex == _messages.length - 1) {
        setState(() {
          _showWorkout = true;
        });
        _timer?.cancel();
      } else {
        setState(() {
          _countdownIndex++;
        });
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final workout = widget.workout;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Start ${workout.name}",
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF111827),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      backgroundColor: Colors.indigo,
      body: Center(
        child: _showWorkout
            ? Card(
                color: const Color(0xFF111827),
                margin: const EdgeInsets.all(20),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        workout.name,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        "Duration: ${workout.duration}",
                        style: const TextStyle(
                          fontSize: 18,
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
                ),
              )
            : Text(
                _messages[_countdownIndex],
                style: const TextStyle(
                  fontSize: 50,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
      ),
    );
  }
}
