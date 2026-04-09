import '../domain/workout_history_entry.dart';

class AnalyticsEngine {
  double totalVolume(List<WorkoutHistoryEntry> history) {
    return history.fold(
      0,
          (sum, e) => sum + (e.weight * e.reps),
    );
  }

  double averageWeight(List<WorkoutHistoryEntry> history) {
    if (history.isEmpty) return 0;
    final total = history.fold(0.0, (sum, e) => sum + e.weight);
    return total / history.length;
  }

  int totalReps(List<WorkoutHistoryEntry> history) {
    return history.fold(0, (sum, e) => sum + e.reps);
  }

  double lastSessionVolume(List<WorkoutHistoryEntry> history) {
    if (history.isEmpty) return 0;
    final last = history.last;
    return last.weight * last.reps;
  }
}