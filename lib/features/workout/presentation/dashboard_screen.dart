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

  List<double> last7Volumes(List<WorkoutHistoryEntry> history) {
    final start = history.length > 7 ? history.length - 7 : 0;
    return history
        .sublist(start)
        .map((e) => e.weight * e.reps)
        .toList();
  }

  double weeklyAverageVolume(List<WorkoutHistoryEntry> history) {
    final volumes = last7Volumes(history);
    if (volumes.isEmpty) return 0;
    return volumes.reduce((a, b) => a + b) / volumes.length;
  }

  bool isWeeklyImproving(List<WorkoutHistoryEntry> history) {
    if (history.length < 14) return false;

    final lastWeek = history
        .sublist(history.length - 7)
        .map((e) => e.weight * e.reps)
        .toList();

    final prevWeek = history
        .sublist(history.length - 14, history.length - 7)
        .map((e) => e.weight * e.reps)
        .toList();

    final lastAvg =
        lastWeek.reduce((a, b) => a + b) / lastWeek.length;
    final prevAvg =
        prevWeek.reduce((a, b) => a + b) / prevWeek.length;

    return lastAvg > prevAvg;
  }
}