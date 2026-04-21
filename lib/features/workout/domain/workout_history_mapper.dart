import '../domain/workout_session.dart';
import '../domain/workout_history_entry.dart';

class WorkoutHistoryMapper {
  static List<WorkoutHistoryEntry> fromSession(WorkoutSession session) {
    final res = <WorkoutHistoryEntry>[];

    for (final g in session.groups) {
      for (final e in g.exercises) {
        for (var i = 0; i < e.sets.length; i++) {
          final s = e.sets[i];

          res.add(
            WorkoutHistoryEntry(
              id: '${session.id}_${e.id}_$i',
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

    return res;
  }
}