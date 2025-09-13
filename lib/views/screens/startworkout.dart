import 'dart:async';
import 'package:audioplayers/audioplayers.dart';
import 'package:fitmeter/providers/workouts_provider.dart';
import 'package:fitmeter/views/screens/workouts.dart';
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

  int _remainingSeconds = 0;
  final AudioPlayer _player = AudioPlayer();

  @override
  void initState() {
    super.initState();
    _playAudio();
    _startCountdown();
  }

  Future<void> _playAudio() async {
    await _player.setPlaybackRate(1.3);
    await _player.play(AssetSource("audio/countdown.mp3"));
  }

  /// Convert hh:mm:ss string to total seconds
  int _parseDuration(String duration) {
    final parts = duration.split(':').map(int.parse).toList();
    if (parts.length == 3) {
      final hours = parts[0];
      final minutes = parts[1];
      final seconds = parts[2];
      return hours * 3600 + minutes * 60 + seconds;
    }
    return 0;
  }

  /// Format seconds back into hh:mm:ss
  String _formatTime(int seconds) {
    final hours = (seconds ~/ 3600).toString().padLeft(2, '0');
    final minutes = ((seconds % 3600) ~/ 60).toString().padLeft(2, '0');
    final secs = (seconds % 60).toString().padLeft(2, '0');
    return "$hours:$minutes:$secs";
  }

  void _startCountdown() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_countdownIndex == _messages.length - 1) {
        setState(() {
          _showWorkout = true;
          _remainingSeconds = _parseDuration(widget.workout.duration);
        });
        _timer?.cancel();
        _startWorkoutTimer();
      } else {
        setState(() {
          _countdownIndex++;
        });
      }
    });
  }

  void _startWorkoutTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingSeconds <= 0) {
        timer.cancel();
      } else {
        setState(() {
          _remainingSeconds--;
        });
      }
    });
  }

  Future<void> _completeWorkoutStatus(
    BuildContext context,
    ref,
    String workoutId,
  ) async {
    await ref
        .read(workoutsNotifierProvider.notifier)
        .completeWorkout(workoutId);
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
                color: const Color(0xFF1F2937), // dark modern color
                margin: const EdgeInsets.all(20),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
                elevation: 8,
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "Workout Started!",
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          SizedBox(
                            width: 300,
                            height: 300,
                            child: CircularProgressIndicator(
                              value:
                                  _remainingSeconds /
                                  _parseDuration(workout.duration),
                              strokeWidth: 12,
                              backgroundColor: Colors.white24,
                              valueColor: const AlwaysStoppedAnimation<Color>(
                                Colors.indigoAccent,
                              ),
                            ),
                          ),
                          Column(
                            children: [
                              Text(
                                workout.name,
                                style: const TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                              _remainingSeconds == 0
                                  ? Center(
                                      child: Row(
                                        mainAxisSize: MainAxisSize
                                            .min, // Ensures row takes only the space it needs
                                        children: [
                                          IconButton(
                                            onPressed: () {
                                              _completeWorkoutStatus(
                                                context,
                                                ref,
                                                workout.id,
                                              );
                                              Navigator.pushReplacement(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (_) =>
                                                      const WorkoutsPage(),
                                                ),
                                              );
                                            },
                                            icon: const Icon(
                                              Icons.check_circle,
                                            ),
                                            color: Colors.blue,
                                            iconSize: 45,
                                            tooltip: 'Complete',
                                          ),
                                          IconButton(
                                            onPressed: () {
                                              _startCountdown();
                                            },
                                            icon: const Icon(Icons.refresh),
                                            color: Colors.red,
                                            iconSize: 50,
                                            tooltip: 'Restart',
                                          ),
                                        ],
                                      ),
                                    )
                                  : Text(
                                      _formatTime(_remainingSeconds),
                                      style: const TextStyle(
                                        fontSize: 48,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                            ],
                          ),
                        ],
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
