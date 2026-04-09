import '../domain/motivation/motivation_event.dart';
import '../domain/workout_session.dart';

class MotivationEventBuilder {
  static MotivationEvent fromExercise({
    required ExerciseSession exercise,
  }) {
    final completedSets =
    exercise.sets.where((s) => s.completed == true).toList();

    if (completedSets.length < 2) {
      return const MotivationEvent(
        repsDiff: 0,
        weightDiff: 0,
        streakDays: 0,
        isComeback: false,
        totalWorkouts: 0,
      );
    }

    final last = completedSets[completedSets.length - 1];
    final prev = completedSets[completedSets.length - 2];

    final repsDiff = last.reps - prev.reps;
    final weightDiff = last.weight - prev.weight;

    return MotivationEvent(
      repsDiff: repsDiff > 0 ? repsDiff : 0,
      weightDiff: weightDiff > 0 ? weightDiff : 0,
      streakDays: 0,
      isComeback: false,
      totalWorkouts: completedSets.length,
    );
  }
}