import '../domain/progression_input.dart';
import '../domain/progression_result.dart';
import '../domain/workout_session.dart';
import '../domain/workout_history_entry.dart';
import 'progression_engine.dart';

class CoachMessageBuilder {
  final ProgressionEngine engine = ProgressionEngine();

  ProgressionResult? build(ExerciseSession exercise) {
    if (exercise.sets.isEmpty) return null;

    final last = exercise.sets.last;

    final history = exercise.sets
        .map((s) => WorkoutHistoryEntry(
      weight: s.weight,
      reps: s.reps,
      date: DateTime.now(),
    ))
        .toList();

    return engine.calculate(
      ProgressionInput(
        lastWeight: last.weight,
        lastReps: last.reps,
        targetReps: last.reps,
        history: history,
      ),
    );
  }

  String buildMessage(ProgressionResult result) {
    final w = result.weight;
    final r = result.reps;

    if (result.reason.contains('Reduce')) {
      return 'Reduce weight: $w kg x $r';
    }

    if (result.reason.contains('plateau')) {
      return 'Push reps: $w kg x $r';
    }

    if (result.reason.contains('Increase weight')) {
      return 'Go heavier: $w kg x $r';
    }

    return 'Keep going: $w kg x $r';
  }
}