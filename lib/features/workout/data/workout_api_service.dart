import 'dart:convert';
import 'package:http/http.dart' as http;
import '../domain/workout_session.dart';
import '../domain/set_log.dart';

class WorkoutApiService {
  final baseUrl = 'http://localhost:8080/api/workout';

  Future<WorkoutSession?> getActiveWorkout() async {
    final res = await http.get(Uri.parse('$baseUrl/active'));
    if (res.statusCode != 200) return null;

    final data = jsonDecode(res.body);

    return WorkoutSession(
      id: data['id'],
      startedAt: DateTime.parse(data['startedAt']),
      exercises: (data['exercises'] as List)
          .map((e) => ExerciseSession(
        id: e['id'],
        name: e['name'],
        order: e['order'],
        sets: (e['sets'] as List)
            .map((s) => SetLog(
          id: s['id'],
          weight: (s['weight'] as num).toDouble(),
          reps: s['reps'],
          completed: s['completed'] ?? false,
        ))
            .toList(),
      ))
          .toList(),
    );
  }

  Future<void> startWorkout() async {
    await http.post(Uri.parse('$baseUrl/start'));
  }

  Future<void> addSet(String exerciseId, double weight, int reps) async {
    await http.post(
      Uri.parse('$baseUrl/set'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'exerciseId': exerciseId,
        'weight': weight,
        'reps': reps,
      }),
    );
  }

  Future<void> updateSet(
      String exerciseId,
      String setId,
      int reps,
      double weight,
      bool completed,
      ) async {
    final res = await http.put(
      Uri.parse('$baseUrl/set'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'exerciseId': exerciseId,
        'setId': setId,
        'reps': reps,
        'weight': weight,
        'completed': completed,
      }),
    );

    if (res.statusCode != 200) {
      throw Exception('updateSet failed');
    }
  }

  Future<List<Map<String, dynamic>>> getHistory(String exerciseId) async {
    final res =
    await http.get(Uri.parse('$baseUrl/history?exerciseId=$exerciseId'));
    if (res.statusCode != 200) return [];
    return List<Map<String, dynamic>>.from(jsonDecode(res.body));
  }
}