import '../../history/application/history_service.dart';
import '../../workout/domain/workout_history_entry.dart';

class GamificationEngine {
  final HistoryService historyService;

  GamificationEngine(this.historyService);

  List<WorkoutHistoryEntry> get history =>
      historyService.getAll();

  int totalXP() {
    if (history.isEmpty) return 0;

    return history.fold(
      0,
          (sum, e) => sum + (e.weight * e.reps).toInt(),
    );
  }

  int level() {
    final xp = totalXP();
    return (xp / 1000).floor();
  }

  int currentStreak() {
    if (history.isEmpty) return 0;

    final sessions = _sessionsSorted();

    int streak = 1;

    for (int i = sessions.length - 1; i > 0; i--) {
      final current = sessions[i].last.date;
      final prev = sessions[i - 1].last.date;

      final diff = current.difference(prev).inDays;

      if (diff <= 1) {
        streak++;
      } else {
        break;
      }
    }

    return streak;
  }

  bool hasPR() {
    if (history.length < 2) return false;

    final volumes = _sessionVolumes();

    return volumes.last > volumes.reduce((a, b) => a > b ? a : b);
  }

  List<List<WorkoutHistoryEntry>> _sessionsSorted() {
    final map = <String, List<WorkoutHistoryEntry>>{};

    for (final e in history) {
      map.putIfAbsent(e.sessionId, () => []).add(e);
    }

    return map.values.toList()
      ..sort((a, b) => a.last.date.compareTo(b.last.date));
  }

  List<double> _sessionVolumes() {
    return _sessionsSorted().map((session) {
      return session.fold(
        0.0,
            (sum, e) => sum + (e.weight * e.reps),
      );
    }).toList();
  }
}