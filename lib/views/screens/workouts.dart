import 'package:fitmeter/model/workouts_model.dart';
import 'package:fitmeter/utils/flutter_secure_storage.dart';
import 'package:fitmeter/views/components/showyesnodialog.dart';
import 'package:fitmeter/providers/workouts_provider.dart';
import 'package:fitmeter/views/screens/login.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class WorkoutsPage extends ConsumerWidget {
  const WorkoutsPage({super.key});

  void _showWorkoutForm(
    BuildContext context,
    WidgetRef ref, {
    WorkoutsModel? workout,
  }) {
    final nameController = TextEditingController(text: workout?.name ?? "");
    final durationController = TextEditingController(
      text: workout?.duration ?? "",
    );

    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: "Workout Form",
      // dim background
      transitionDuration: const Duration(milliseconds: 350),
      pageBuilder: (context, anim1, anim2) {
        return Align(
          alignment: Alignment.bottomCenter,
          child: Material(
            color: Colors.transparent,
            child: Container(
              margin: const EdgeInsets.only(bottom: 20, left: 16, right: 16),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(blurRadius: 20, offset: const Offset(0, 10)),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    workout == null ? "Add Workout" : "Update Workout",
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: nameController,
                    decoration: const InputDecoration(
                      labelText: "Name",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: durationController,
                    decoration: const InputDecoration(
                      labelText: "Duration",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text(
                          "Cancel",
                          style: TextStyle(color: Colors.redAccent),
                        ),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF111827),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: () async {
                          if (workout == null) {
                            await ref
                                .read(workoutsNotifierProvider.notifier)
                                .addWorkout(
                                  nameController.text,
                                  durationController.text,
                                );
                          } else {
                            await ref
                                .read(workoutsNotifierProvider.notifier)
                                .updateWorkout(
                                  workout.id,
                                  nameController.text,
                                  durationController.text,
                                );
                          }
                          if (context.mounted) Navigator.pop(context);
                        },
                        child: const Text(
                          "Submit",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
      transitionBuilder: (context, anim1, anim2, child) {
        final curvedValue =
            Curves.easeOutCubic.transform(anim1.value) - 1.0; // smooth ease
        return Transform.translate(
          offset: Offset(0, curvedValue * -200), // slide from bottom
          child: Opacity(opacity: anim1.value, child: child),
        );
      },
    );
  }

  Future<void> _confirmDelete(
    BuildContext context,
    WidgetRef ref,
    String workoutId,
  ) async {
    final confirm = await showYesNoDialog(
      context: context,
      title: "Delete Workout",
      message: "Are you sure you want to delete this workout?",
      yesLabel: "Yes",
      noLabel: "No",
    );

    if (confirm == true) {
      await ref
          .read(workoutsNotifierProvider.notifier)
          .deleteWorkout(workoutId);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final workoutsState = ref.watch(workoutsNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text("FitMeter", style: TextStyle(color: Colors.white)),
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
          if (workouts.isEmpty) {
            return const Center(
              child: Text("No Workouts", style: TextStyle(color: Colors.white)),
            );
          }
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
                  title: Text(
                    workout.name,
                    style: const TextStyle(color: Colors.white),
                  ),
                  subtitle: Text(
                    "Duration: ${workout.duration}\nStatus: ${workout.status}",
                    style: const TextStyle(color: Colors.white70),
                  ),
                  trailing: PopupMenuButton<String>(
                    icon: const Icon(Icons.more_vert, color: Colors.white),
                    onSelected: (value) {
                      if (value == 'update') {
                        _showWorkoutForm(context, ref, workout: workout);
                      } else if (value == 'delete') {
                        _confirmDelete(context, ref, workout.id);
                      }
                    },
                    itemBuilder: (_) => const [
                      PopupMenuItem(value: 'update', child: Text("Update")),
                      PopupMenuItem(value: 'delete', child: Text("Delete")),
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
          child: Text("No Workouts", style: TextStyle(color: Colors.white)),
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
