import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/workout_provider.dart';

class WorkoutSummary {
  final double totalVolume;
  final int totalReps;
  final int totalSets;
  final int exercises;

  const WorkoutSummary({
    required this.totalVolume,
    required this.totalReps,
    required this.totalSets,
    required this.exercises,
  });
}

final summaryProvider = Provider<WorkoutSummary?>((ref) {
  final state = ref.watch(workoutProvider);
  final session = state.session;

  if (session == null) return null;

  double volume = 0;
  int reps = 0;
  int sets = 0;
  int exercises = 0;

  for (final group in session.groups) {
    for (final exercise in group.exercises) {
      exercises++;

      for (final set in exercise.sets) {
        volume += set.weight * set.reps;
        reps += set.reps;
        sets++;
      }
    }
  }

  return WorkoutSummary(
    totalVolume: volume,
    totalReps: reps,
    totalSets: sets,
    exercises: exercises,
  );
});