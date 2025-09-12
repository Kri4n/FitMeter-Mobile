import 'dart:convert';
import 'package:fitmeter_mobile/data/api_routes.dart';
import 'package:fitmeter_mobile/model/workouts_model.dart';
import 'package:fitmeter_mobile/utils/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class ApiService {
  static Future<List<WorkoutsModel>> fetchWorkouts() async {
    final token = await SecureStorage.readToken();
    final response = await http.get(
      Uri.parse(ApiRoutes.getWorkouts),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((e) => WorkoutsModel.fromJson(e)).toList();
    } else {
      throw Exception("Failed to load workouts");
    }
  }

  static Future<void> addWorkout(String name, String duration) async {
    final token = await SecureStorage.readToken();
    final response = await http.post(
      Uri.parse(ApiRoutes.addWorkout),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({'name': name, 'duration': duration}),
    );

    if (response.statusCode != 201) {
      throw Exception("Failed to add workout");
    }
  }

  static Future<void> updateWorkout(
    String id,
    String name,
    String duration,
  ) async {
    final token = await SecureStorage.readToken();
    final response = await http.patch(
      ApiRoutes.updateWorkout(id),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({'name': name, 'duration': duration}),
    );

    if (response.statusCode != 200) {
      throw Exception("Failed to update workout");
    }
  }

  static Future<void> deleteWorkout(String id) async {
    final token = await SecureStorage.readToken();
    final response = await http.delete(
      ApiRoutes.deleteWorkout(id),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode != 200) {
      throw Exception("Failed to delete workout");
    }
  }
}
