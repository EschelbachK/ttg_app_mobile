import '../../workout/domain/workout_history_entry.dart';

class ProgressAnalyticsEngine {
  final List<WorkoutHistoryEntry> history;

  ProgressAnalyticsEngine(this.history);

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
  // SESSION VOLUME
  // ─────────────────────────────
  double sessionVolume(List<WorkoutHistoryEntry> session) {
    return session.fold(
      0,
          (sum, e) => sum + (e.weight * e.reps),
    );
  }

  List<double> volumeSeries() {
    return sessions.map(sessionVolume).toList();
  }

  // ─────────────────────────────
  // TREND (% change)
  // ─────────────────────────────
  double progressTrend() {
    final v = volumeSeries();
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
    final v = volumeSeries();
    if (v.length < 2) return false;
    return v.last > v.first;
  }

  // ─────────────────────────────
  // MUSCLE HEATMAP
  // ─────────────────────────────
  Map<String, double> muscleHeatmap() {
    final map = <String, double>{};

    for (final e in history) {
      map[e.exerciseName] =
          (map[e.exerciseName] ?? 0) + (e.weight * e.reps);
    }

    return map;
  }

  // ─────────────────────────────
  // PERSONAL RECORDS
  // ─────────────────────────────
  Map<String, double> personalRecords() {
    final map = <String, double>{};

    for (final e in history) {
      final volume = e.weight * e.reps;

      if (volume > (map[e.exerciseName] ?? 0)) {
        map[e.exerciseName] = volume;
      }
    }

    return map;
  }

  // ─────────────────────────────
  // SESSION COMPARISON
  // ─────────────────────────────
  Map<String, double> compareLastSessions() {
    final s = sessions;
    if (s.length < 2) return {};

    final last = sessionVolume(s[s.length - 1]);
    final prev = sessionVolume(s[s.length - 2]);

    return {
      "last": last,
      "previous": prev,
      "diff": last - prev,
      "percent": prev == 0 ? 0 : ((last - prev) / prev) * 100,
    };
  }
}