import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../workout/application/workout_history_store.dart';
import '../../workout/application/workout_summary_mapper.dart';
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
    final entries = WorkoutSummaryMapper.toHistory(session);
    if (entries.isEmpty) return;

    for (final e in entries) {
      _store.add(e);
    }
  }

  List<WorkoutHistoryEntry> getAll() {
    return _store.entries;
  }

  void clear() {
    _store.clear();
  }
}