import 'workout_history_entry.dart';

class ProgressionInput {
  final double lastWeight;
  final int lastReps;
  final int targetReps;
  final List<WorkoutHistoryEntry> history;

  const ProgressionInput({
    required this.lastWeight,
    required this.lastReps,
    required this.targetReps,
    required this.history,
  });
}