import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../workout/application/workout_history_store.dart';
import '../../workout/domain/workout_history_entry.dart';
import '../../workout/domain/workout_session.dart';

final historyServiceProvider = Provider<HistoryService>((ref) {
  final store = ref.read(workoutHistoryStoreProvider.notifier);
  return HistoryService(store);
});

class HistoryService {
  final WorkoutHistoryStore _store;
  HistoryService(this._store);

  void saveSession(WorkoutSession session) {
    final entries = <WorkoutHistoryEntry>[];

    for (final group in session.groups) {
      for (final exercise in group.exercises) {
        for (var i = 0; i < exercise.sets.length; i++) {
          final set = exercise.sets[i];

          entries.add(
            WorkoutHistoryEntry(
              id: '${session.id}_${exercise.id}_$i',
              sessionId: session.id,
              date: session.startedAt,
              exerciseName: exercise.name,
              weight: set.weight,
              reps: set.reps,
            ),
          );
        }
      }
    }

    if (entries.isEmpty) return;

    for (final e in entries) {
      _store.add(e);
    }
  }

  List<WorkoutHistoryEntry> getAll() => _store.entries;

  void clear() => _store.clear();
}