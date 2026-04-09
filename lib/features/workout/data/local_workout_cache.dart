import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../domain/workout_session.dart';

class LocalWorkoutCache {
  Future<void> saveSession(WorkoutSession session) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('workout_session', jsonEncode({
      'id': session.id,
      'startedAt': session.startedAt.toIso8601String(),
    }));
  }

  Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('workout_session');
  }
}