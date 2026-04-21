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

  void add(WorkoutHistoryEntry e) => state = [...state, e];

  void addSession(WorkoutSession session) {
    final entries = WorkoutSummaryMapper.toHistory(session);
    if (entries.isNotEmpty) state = [...state, ...entries];
  }

  List<WorkoutHistoryEntry> get entries => state;

  List<List<WorkoutHistoryEntry>> get sessions {
    final grouped = <String, List<WorkoutHistoryEntry>>{};

    for (final e in state) {
      (grouped[e.sessionId] ??= []).add(e);
    }

    final list = grouped.values.toList();

    list.sort((a, b) => b.first.date.compareTo(a.first.date));

    return list;
  }

  void clear() => state = [];
}