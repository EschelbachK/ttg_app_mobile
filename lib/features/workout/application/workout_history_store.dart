import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/workout_session.dart';
import '../domain/workout_history_entry.dart';
import 'workout_summary_mapper.dart';

final workoutHistoryStoreProvider =
StateNotifierProvider<WorkoutHistoryStore, List<WorkoutHistoryEntry>>(
      (ref) => WorkoutHistoryStore(ref),
);

class WorkoutHistoryStore extends StateNotifier<List<WorkoutHistoryEntry>> {
  final Ref ref;

  WorkoutHistoryStore(this.ref) : super([]);

  void add(WorkoutHistoryEntry entry) {
    state = [...state, entry];
  }

  void addSession(WorkoutSession session) {
    final entries = WorkoutSummaryMapper.toHistory(session);
    if (entries.isEmpty) return;

    state = [...state, ...entries];
  }

  List<WorkoutHistoryEntry> get entries => state;

  List<List<WorkoutHistoryEntry>> get sessions {
    final Map<String, List<WorkoutHistoryEntry>> grouped = {};

    for (final e in state) {
      final key = e.sessionId;
      grouped.putIfAbsent(key, () => []);
      grouped[key]!.add(e);
    }

    return grouped.values.toList()
      ..sort((a, b) => a.first.date.compareTo(b.first.date));
  }

  void clear() {
    state = [];
  }
}