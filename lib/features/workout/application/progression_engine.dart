import '../domain/progression_input.dart';
import '../domain/progression_result.dart';

class ProgressionEngine {
  ProgressionResult calculate(ProgressionInput input) {
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
        reason: 'deload',
      );
    }

    return ProgressionResult(
      suggestedWeight: input.lastWeight,
      suggestedReps: input.targetReps,
      reason: 'maintain',
    );
  }
}