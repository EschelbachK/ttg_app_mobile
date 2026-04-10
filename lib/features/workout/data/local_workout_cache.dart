import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../domain/set_log.dart';
import '../domain/workout_session.dart';
import '../domain/workout_group.dart';

class LocalWorkoutCache {
  static const _key = 'workout_session';

  Future<void> save(WorkoutSession session) async {
    final prefs = await SharedPreferences.getInstance();

    final data = {
      'id': session.id,
      'startedAt': session.startedAt.toIso8601String(),
      'groups': session.groups.map((g) {
        return {
          'name': g.name,
          'order': g.order,
          'exercises': g.exercises.map((e) {
            return {
              'id': e.id,
              'name': e.name,
              'order': e.order,
              'sets': e.sets.map((s) {
                return {
                  'id': s.id,
                  'weight': s.weight,
                  'reps': s.reps,
                  'completed': s.completed,
                };
              }).toList(),
            };
          }).toList(),
        };
      }).toList(),
    };

    await prefs.setString(_key, jsonEncode(data));
  }

  Future<WorkoutSession?> load() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_key);
    if (raw == null) return null;

    final data = jsonDecode(raw);

    final groups = (data['groups'] as List? ?? []).map((g) {
      return WorkoutGroup(
        name: g['name'],
        order: g['order'],
        exercises: (g['exercises'] as List? ?? []).map((e) {
          return ExerciseSession(
            id: e['id'],
            name: e['name'],
            order: e['order'],
            sets: (e['sets'] as List? ?? []).map((s) {
              return SetLog(
                id: s['id'],
                weight: (s['weight'] as num).toDouble(),
                reps: s['reps'],
                completed: s['completed'] ?? false,
              );
            }).toList(),
          );
        }).toList(),
      );
    }).toList();

    return WorkoutSession(
      id: data['id'],
      startedAt: DateTime.parse(data['startedAt']),
      groups: groups,
    );
  }

  Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
  }
}