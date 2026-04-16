import '../domain/workout_session.dart';
import '../domain/workout_history_entry.dart';

class WorkoutSummaryMapper {
  static List<WorkoutHistoryEntry> toHistory(WorkoutSession session) {
    final result = <WorkoutHistoryEntry>[];

    for (final g in session.groups) {
      for (final e in g.exercises) {
        for (final s in e.sets) {
          result.add(
            WorkoutHistoryEntry(
              id: s.id,
              exerciseName: e.name,
              weight: s.weight,
              reps: s.reps,
              date: session.startedAt,
              sessionId: session.id,
            ),
          );
        }
      }
    }

    return result;
  }
}