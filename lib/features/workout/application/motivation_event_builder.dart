import '../domain/motivation/motivation_event.dart';
import '../domain/workout_session.dart';

class MotivationEventBuilder {
  static MotivationEvent fromExercise({
    required ExerciseSession exercise,
  }) {
    final sets = exercise.sets;
    if (sets.length < 2) {
      return const MotivationEvent(
        repsDiff: 0,
        weightDiff: 0,
        streakDays: 0,
        isComeback: false,
        totalWorkouts: 0,
      );
    }

    final completed = sets.where((s) => s.completed == true).toList();
    if (completed.length < 2) {
      return const MotivationEvent(
        repsDiff: 0,
        weightDiff: 0,
        streakDays: 0,
        isComeback: false,
        totalWorkouts: 0,
      );
    }

    final last = completed[completed.length - 1];
    final prev = completed[completed.length - 2];

    final repsDiff = last.reps - prev.reps;
    final weightDiff = last.weight - prev.weight;

    return MotivationEvent(
      repsDiff: repsDiff > 0 ? repsDiff : 0,
      weightDiff: weightDiff > 0 ? weightDiff : 0,
      streakDays: 0,
      isComeback: false,
      totalWorkouts: completed.length,
    );
  }
}