import '../domain/workout_session.dart';
import '../domain/workout_history_entry.dart';

class WorkoutSummaryMapper {
  static List<WorkoutHistoryEntry> toHistory(WorkoutSession session) {
    return session.groups
        .expand((g) => g.exercises)
        .expand((e) => e.sets)
        .where((s) => s.completed)
        .map((s) => WorkoutHistoryEntry(
      weight: s.weight,
      reps: s.reps,
      date: DateTime.now(),
    ))
        .toList();
  }

  static double totalVolume(WorkoutSession session) {
    return session.groups
        .expand((g) => g.exercises)
        .expand((e) => e.sets)
        .where((s) => s.completed)
        .fold(0.0, (sum, s) => sum + s.weight * s.reps);
  }
}