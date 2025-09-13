import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiRoutes {
  static String? url = dotenv.env['API_URL'];
  // User
  static String login = "$url/users/login";
  static String register = "$url/users/register";

  // Workouts
  static String getWorkouts = "$url/workouts/getMyWorkouts";
  static String addWorkout = "$url/workouts/addWorkout";
  static Uri deleteWorkout(String workoutId) {
    return Uri.parse("$url/workouts/deleteWorkout/$workoutId");
  }

  static Uri updateWorkout(String workoutId) {
    return Uri.parse("$url/workouts/updateWorkout/$workoutId");
  }

  static Uri completeWorkout(String workoutId) {
    return Uri.parse("$url/workouts/completeWorkoutStatus/$workoutId");
  }
}
