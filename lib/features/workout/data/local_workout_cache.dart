import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../domain/set_log.dart';
import '../domain/workout_session.dart';

class LocalWorkoutCache {
  static const _key = 'workout_session';

  Future<void> save(WorkoutSession session) async {
    final prefs = await SharedPreferences.getInstance();

    final json = jsonEncode({
      'id': session.id,
      'startedAt': session.startedAt.toIso8601String(),
      'exercises': session.exercises
          .map((e) => {
        'id': e.id,
        'name': e.name,
        'order': e.order,
        'sets': e.sets
            .map((s) => {
          'id': s.id,
          'weight': s.weight,
          'reps': s.reps,
          'completed': s.completed,
        })
            .toList(),
      })
          .toList(),
    });

    await prefs.setString(_key, json);
  }

  Future<WorkoutSession?> load() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_key);
    if (raw == null) return null;

    final data = jsonDecode(raw);

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
          completed: s['completed'],
        ))
            .toList(),
      ))
          .toList(),
    );
  }

  Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
  }
}