import 'package:dio/dio.dart';
import '../domain/workout_session.dart';
import '../domain/workout_group.dart';
import '../domain/set_log.dart';

class WorkoutApiService {
  final Dio dio;

  WorkoutApiService(this.dio);

  Future<WorkoutSession?> getActiveWorkout() async {
    try {
      final res = await dio.get('/workout/active');
      final data = res.data;
      if (data == null) return null;

      final exercises = (data['exercises'] as List? ?? [])
          .asMap()
          .entries
          .map((e) {
        final ex = e.value;

        return ExerciseSession(
          id: ex['id'],
          name: ex['name'],
          order: e.key,
          sets: (ex['sets'] as List? ?? []).map((s) {
            return SetLog(
              id: s['id'],
              weight: (s['weight'] as num).toDouble(),
              reps: s['reps'],
              completed: s['completed'] ?? false,
            );
          }).toList(),
        );
      }).toList();

      return WorkoutSession(
        id: data['id'],
        startedAt: DateTime.parse(data['startedAt']),
        groups: [
          WorkoutGroup(
            name: 'Session',
            order: 0,
            exercises: exercises,
          )
        ],
      );
    } catch (_) {
      return null;
    }
  }

  Future<void> startWorkout() async => dio.post('/workout/start');

  Future<void> addSet(String exerciseId, double weight, int reps) async =>
      dio.post('/sets', data: {
        'exerciseId': exerciseId,
        'weight': weight,
        'reps': reps,
      });

  Future<void> updateSet(
      String exerciseId,
      String setId,
      int reps,
      double weight,
      bool completed,
      ) async =>
      dio.patch('/sets/$setId', data: {
        'exerciseId': exerciseId,
        'reps': reps,
        'weight': weight,
        'completed': completed,
      });

  Future<void> deleteSet(String exerciseId, String setId) async =>
      dio.delete('/sets/$setId', data: {'exerciseId': exerciseId});

  Future<void> finishWorkout(WorkoutSession session) async =>
      dio.post('/workout/finish', data: {'id': session.id});

  Future<void> reorderExercises(List<Map<String, dynamic>> data) async =>
      dio.post('/exercises/reorder', data: data);
}