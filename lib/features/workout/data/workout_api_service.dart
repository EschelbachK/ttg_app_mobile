import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/network/api_client.dart';
import '../domain/workout_session.dart';
import '../domain/set_log.dart';

final workoutApiServiceProvider = Provider<WorkoutApiService>((ref) {
  return WorkoutApiService(ref.read(apiClientProvider));
});

class WorkoutApiService {
  final ApiClient api;

  WorkoutApiService(this.api);

  Future<WorkoutSession?> getActiveWorkout() async {
    final res = await api.get('/workout/active');
    if (res.statusCode != 200 || res.data == null) return null;

    final data = res.data;

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
    await api.post('/workout/start');
  }

  Future<void> addSet(String exerciseId, double weight, int reps) async {
    await api.post('/workout/set', data: {
      'exerciseId': exerciseId,
      'weight': weight,
      'reps': reps,
    });
  }

  Future<void> updateSet(
      String exerciseId,
      String setId,
      int reps,
      double weight,
      bool completed,
      ) async {
    final res = await api.put('/workout/set', data: {
      'exerciseId': exerciseId,
      'setId': setId,
      'reps': reps,
      'weight': weight,
      'completed': completed,
    });

    if (res.statusCode != 200) {
      throw Exception('updateSet failed');
    }
  }

  Future<List<Map<String, dynamic>>> getHistory(String exerciseId) async {
    final res = await api.get('/workout/history', query: {
      'exerciseId': exerciseId,
    });

    if (res.statusCode != 200 || res.data == null) return [];
    return List<Map<String, dynamic>>.from(res.data);
  }
}