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
    final history = exercise.sets.map((s) => WorkoutHistoryEntry(
      weight: s.weight,
      reps: s.reps,
      date: DateTime.now(),
    )).toList();
    return engine.calculate(ProgressionInput(
      lastWeight: last.weight,
      lastReps: last.reps,
      targetReps: last.reps,
      history: history,
    ));
  }
}