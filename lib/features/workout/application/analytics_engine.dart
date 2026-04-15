import '../domain/workout_history_entry.dart';

class AnalyticsEngine {
  double totalVolume(List<WorkoutHistoryEntry> h) =>
      h.fold(0, (s, e) => s + e.weight * e.reps);

  double averageWeight(List<WorkoutHistoryEntry> h) =>
      h.isEmpty ? 0 : h.fold(0.0, (s, e) => s + e.weight) / h.length;

  int totalReps(List<WorkoutHistoryEntry> h) =>
      h.fold(0, (s, e) => s + e.reps);

  bool isImproving(List<WorkoutHistoryEntry> h) =>
      volumeChangePercent(h) > 0;

  double _volume(WorkoutHistoryEntry e) => e.weight * e.reps;

  double _avg(List<double> v) => v.reduce((a, b) => a + b) / v.length;

  double lastSessionVolume(List<WorkoutHistoryEntry> h) =>
      h.isEmpty ? 0 : _volume(h.last);

  double previousSessionVolume(List<WorkoutHistoryEntry> h) =>
      h.length < 2 ? 0 : _volume(h[h.length - 2]);

  double volumeChangePercent(List<WorkoutHistoryEntry> h) {
    final prev = previousSessionVolume(h);
    if (prev == 0) return 0;
    return ((lastSessionVolume(h) - prev) / prev) * 100;
  }
}