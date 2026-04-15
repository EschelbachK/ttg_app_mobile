import '../domain/workout_session.dart';
import '../domain/workout_history_entry.dart';

class WorkoutHistoryMapper {

  static List<WorkoutHistoryEntry> fromSession(WorkoutSession session) {
    final List<WorkoutHistoryEntry> result = [];

    for (final g in session.groups) {
      for (final e in g.exercises) {
        for (final s in e.sets) {
          result.add(
            WorkoutHistoryEntry(
              id: s.id,
              exerciseName: e.name,
              sessionId: session.id,
              weight: s.weight,
              reps: s.reps,
              date: session.startedAt,
            ),
          );
        }
      }
    }

    return result;
  }
}