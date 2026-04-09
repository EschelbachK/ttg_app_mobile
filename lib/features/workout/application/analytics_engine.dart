import '../domain/workout_history_entry.dart';

class AnalyticsEngine {
  double totalVolume(List<WorkoutHistoryEntry> history) {
    return history.fold(0, (sum, e) => sum + (e.weight * e.reps));
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

  double previousSessionVolume(List<WorkoutHistoryEntry> history) {
    if (history.length < 2) return 0;
    final prev = history[history.length - 2];
    return prev.weight * prev.reps;
  }

  double volumeChangePercent(List<WorkoutHistoryEntry> history) {
    final last = lastSessionVolume(history);
    final prev = previousSessionVolume(history);
    if (prev == 0) return 0;
    return ((last - prev) / prev) * 100;
  }

  bool isImproving(List<WorkoutHistoryEntry> history) {
    return volumeChangePercent(history) > 0;
  }
}