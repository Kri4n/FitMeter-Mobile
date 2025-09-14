import 'package:fitmeter/model/workouts_model.dart';
import 'package:fitmeter/utils/flutter_secure_storage.dart';
import 'package:fitmeter/views/components/showyesnodialog.dart';
import 'package:fitmeter/providers/workouts_provider.dart';
import 'package:fitmeter/views/components/workoutform.dart';
import 'package:fitmeter/views/screens/login.dart';
import 'package:fitmeter/views/screens/startworkout.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class WorkoutsPage extends ConsumerStatefulWidget {
  const WorkoutsPage({super.key});

  @override
  ConsumerState<WorkoutsPage> createState() => _WorkoutsPageState();
}

class _WorkoutsPageState extends ConsumerState<WorkoutsPage> {
  Future<void> _showWorkoutForm(
    BuildContext context,
    WidgetRef ref, {
    WorkoutsModel? workout,
  }) async {
    showDialog(
      context: context,
      builder: (context) => WorkoutForm(
        workout: workout,
        onSubmit: (name, duration) async {
          if (workout == null) {
            await ref
                .read(workoutsNotifierProvider.notifier)
                .addWorkout(name, duration);
          } else {
            await ref
                .read(workoutsNotifierProvider.notifier)
                .updateWorkout(workout.id, name, duration);
          }
        },
      ),
    );
  }

  Future<void> _deleteWorkout(
    BuildContext context,
    ref,
    String workoutId,
  ) async {
    await ref.read(workoutsNotifierProvider.notifier).deleteWorkout(workoutId);
  }

  @override
  Widget build(BuildContext context) {
    final workoutsState = ref.watch(workoutsNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Image.asset('assets/fitmeter-logo.png', height: 30),
            const SizedBox(width: 8),
            const Text(
              "FitMeter",
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        backgroundColor: const Color(0xFF111827),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            onPressed: () async {
              final result = await showYesNoDialog(
                context: context,
                title: "Logout",
                message: "Are you sure you want to logout?",
                yesLabel: "Yes",
                noLabel: "No",
              );
              if (result == true) {
                await SecureStorage.deleteToken();
                //  Clear workout state
                ref.invalidate(workoutsNotifierProvider);
                if (context.mounted) {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => const LoginPage()),
                  );
                }
              }
            },
          ),
        ],
      ),
      backgroundColor: Colors.indigo,
      body: workoutsState.when(
        data: (workouts) {
          return ListView.builder(
            padding: const EdgeInsets.all(8),
            itemCount: workouts.length,
            itemBuilder: (context, index) {
              final workout = workouts[index];
              return Card(
                color: const Color(0xFF111827),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListTile(
                  title: RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: workout.name,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const WidgetSpan(
                          child: Spacer(), // pushes status to the right
                        ),
                        WidgetSpan(
                          alignment: PlaceholderAlignment.middle,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const SizedBox(width: 3),
                              workout.status.toLowerCase() == "pending"
                                  ? const Icon(
                                      Icons.access_time,
                                      size: 16,
                                      color: Colors.amberAccent,
                                    )
                                  : const Icon(
                                      Icons.check_circle,
                                      size: 16,
                                      color: Colors.green,
                                    ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        workout.duration,
                        style: const TextStyle(color: Colors.white70),
                      ),
                    ],
                  ),

                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ElevatedButton.icon(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  StartWorkoutPage(workout: workout),
                            ),
                          );
                          if (kDebugMode) {
                            print("Start workout: ${workout.id}");
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        label: const Text(
                          "Start",
                          style: TextStyle(color: Colors.white),
                        ),
                        icon: const Icon(
                          Icons.play_arrow,
                          color: Colors.white,
                          size: 14,
                        ),
                      ),
                      PopupMenuButton<String>(
                        icon: const Icon(Icons.more_vert, color: Colors.white),
                        onSelected: (value) {
                          if (value == 'update') {
                            _showWorkoutForm(context, ref, workout: workout);
                          } else if (value == 'delete') {
                            _deleteWorkout(context, ref, workout.id);
                          }
                        },
                        itemBuilder: (_) => const [
                          PopupMenuItem(value: 'update', child: Text("Update")),
                          PopupMenuItem(value: 'delete', child: Text("Delete")),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
        loading: () =>
            const Center(child: CircularProgressIndicator(color: Colors.white)),
        error: (e, _) => const Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.fitness_center_rounded,
                size: 100,
                color: Colors.white,
              ),
              SizedBox(height: 8),
              Text(
                "No Workouts",
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 20),
        child: FloatingActionButton(
          onPressed: () => _showWorkoutForm(context, ref),
          backgroundColor: Colors.white,
          child: const Icon(Icons.add, size: 30, color: Colors.blueAccent),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
