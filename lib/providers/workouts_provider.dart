import 'package:fitmeter_mobile/services/api_services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fitmeter_mobile/model/workouts_model.dart';

/// Fetch workouts from API
final workoutsProvider = FutureProvider<List<WorkoutsModel>>((ref) async {
  return ApiService.fetchWorkouts();
});

/// StateNotifier for CRUD operations
class WorkoutsNotifier extends StateNotifier<AsyncValue<List<WorkoutsModel>>> {
  WorkoutsNotifier() : super(const AsyncValue.loading()) {
    _loadWorkouts();
  }

  Future<void> _loadWorkouts() async {
    try {
      final workouts = await ApiService.fetchWorkouts();
      state = AsyncValue.data(workouts);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> addWorkout(String name, String duration) async {
    try {
      await ApiService.addWorkout(name, duration);
      _loadWorkouts();
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> updateWorkout(String id, String name, String duration) async {
    try {
      await ApiService.updateWorkout(id, name, duration);
      _loadWorkouts();
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> deleteWorkout(String id) async {
    try {
      await ApiService.deleteWorkout(id);
      _loadWorkouts();
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}

final workoutsNotifierProvider =
    StateNotifierProvider<WorkoutsNotifier, AsyncValue<List<WorkoutsModel>>>(
      (ref) => WorkoutsNotifier(),
    );
