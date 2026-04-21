import '../../workout/domain/workout_history_entry.dart';

class PRService {
  static Map<String, double> maxWeight(List<WorkoutHistoryEntry> entries) {
    final map = <String, double>{};

    for (final e in entries) {
      final current = map[e.exerciseName] ?? 0;

      if (e.weight > current) {
        map[e.exerciseName] = e.weight;
      }
    }

    return map;
  }

  static bool isPR(
      WorkoutHistoryEntry entry,
      List<WorkoutHistoryEntry> all,
      ) {
    final best = maxWeight(all)[entry.exerciseName] ?? 0;
    return entry.weight >= best;
  }
}