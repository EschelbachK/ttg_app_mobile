import '../domain/progression_input.dart';
import '../domain/progression_result.dart';
import '../domain/workout_history_entry.dart';

class ProgressionEngine {
  ProgressionResult calculate(ProgressionInput input) {
    final weight = input.lastWeight;
    final reps = input.lastReps;
    final targetReps = input.targetReps;
    final history = input.history;

    final isPlateau = _isPlateau(history);
    final isRegression = _isRegression(history);

    double newWeight = weight;
    int newReps = reps;
    String reason;

    if (isRegression) {
      newWeight = weight * 0.95;
      reason = 'Reduce weight to recover';
    } else if (isPlateau) {
      newReps = reps + 1;
      reason = 'Increase reps to break plateau';
    } else if (reps >= targetReps) {
      newWeight = weight + 2.5;
      newReps = targetReps;
      reason = 'Increase weight';
    } else {
      newReps = reps + 1;
      reason = 'Progress reps';
    }

    return ProgressionResult(
      weight: double.parse(newWeight.toStringAsFixed(1)),
      reps: newReps,
      reason: reason,
    );
  }

  bool _isPlateau(List<WorkoutHistoryEntry> h) {
    if (h.length < 3) return false;

    final v1 = _volume(h[h.length - 1]);
    final v2 = _volume(h[h.length - 2]);
    final v3 = _volume(h[h.length - 3]);

    return v1 == v2 && v2 == v3;
  }

  bool _isRegression(List<WorkoutHistoryEntry> h) {
    if (h.length < 2) return false;

    final last = _volume(h[h.length - 1]);
    final prev = _volume(h[h.length - 2]);

    return last < prev;
  }

  double _volume(WorkoutHistoryEntry e) =>
      e.weight * e.reps;
}