import '../domain/progression_input.dart';
import '../domain/progression_result.dart';

class ProgressionEngine {
  ProgressionResult calculate(ProgressionInput input) {
    final history = input.history;

    if (history.length >= 3) {
      final last3 = history.take(3).toList();

      final isPlateau = last3.every(
            (e) => e.reps <= input.targetReps,
      );

      if (isPlateau) {
        return ProgressionResult(
          suggestedWeight: input.lastWeight - 2.5,
          suggestedReps: input.targetReps,
          reason: 'plateau_deload',
        );
      }
    }

    if (input.lastReps >= input.targetReps) {
      return ProgressionResult(
        suggestedWeight: input.lastWeight + 2.5,
        suggestedReps: input.targetReps,
        reason: 'increase',
      );
    }

    if (input.lastReps < input.targetReps - 2) {
      return ProgressionResult(
        suggestedWeight: input.lastWeight - 2.5,
        suggestedReps: input.targetReps,
        reason: 'fatigue',
      );
    }

    return ProgressionResult(
      suggestedWeight: input.lastWeight,
      suggestedReps: input.targetReps,
      reason: 'maintain',
    );
  }
}