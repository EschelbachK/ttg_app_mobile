import '../domain/progression_input.dart';
import '../domain/progression_result.dart';

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

  bool _isPlateau(List history) {
    if (history.length < 3) return false;
    final last3 = history.sublist(history.length - 3);
    final values = last3.map((e) => e.weight * e.reps).toList();
    return values[2] == values[1] && values[1] == values[0];
  }

  bool _isRegression(List history) {
    if (history.length < 2) return false;
    final last = history[history.length - 1];
    final prev = history[history.length - 2];
    return (last.weight * last.reps) < (prev.weight * prev.reps);
  }
}