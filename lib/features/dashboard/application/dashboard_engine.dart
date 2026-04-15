import '../../workout/domain/workout_history_entry.dart';

class DashboardEngine {
  final List<WorkoutHistoryEntry> history;

  DashboardEngine(this.history);

  // ─────────────────────────────
  // SESSION GROUPING
  // ─────────────────────────────
  List<List<WorkoutHistoryEntry>> get sessions {
    final map = <String, List<WorkoutHistoryEntry>>{};

    for (final e in history) {
      map.putIfAbsent(e.sessionId, () => []).add(e);
    }

    return map.values.toList()
      ..sort((a, b) => a.first.date.compareTo(b.first.date));
  }

  // ─────────────────────────────
  // VOLUME PER SESSION
  // ─────────────────────────────
  List<double> volumePerSession() {
    return sessions.map((session) {
      return session.fold(
        0.0,
            (sum, e) => sum + (e.weight * e.reps),
      );
    }).toList();
  }

  // ─────────────────────────────
  // TREND
  // ─────────────────────────────
  double progressTrend() {
    final v = volumePerSession();
    if (v.length < 2) return 0;

    final last = v.last;
    final prev = v[v.length - 2];

    if (prev == 0) return 0;

    return ((last - prev) / prev) * 100;
  }

  // ─────────────────────────────
  // IMPROVEMENT
  // ─────────────────────────────
  bool isImproving() {
    final v = volumePerSession();
    if (v.length < 2) return false;
    return v.last > v.first;
  }

  // ─────────────────────────────
  // WEEKLY VOLUME
  // ─────────────────────────────
  double weeklyVolume() {
    return history.fold(
      0.0,
          (sum, e) => sum + (e.weight * e.reps),
    );
  }

  // ─────────────────────────────
  // MUSCLE / EXERCISE HEATMAP
  // ─────────────────────────────
  Map<String, double> muscleHeatmap() {
    final map = <String, double>{};

    for (final e in history) {
      map[e.exerciseName] =
          (map[e.exerciseName] ?? 0) + (e.weight * e.reps);
    }

    return map;
  }
}