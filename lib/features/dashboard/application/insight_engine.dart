import '../../workout/domain/workout_history_entry.dart';
import '../domain/insight_models.dart';

class InsightEngine {
  const InsightEngine();

  InsightDashboardData build(List<WorkoutHistoryEntry> history) {
    final sessions = _group(history);
    final volumes = _volumes(sessions);

    return InsightDashboardData(
      sessions: _sessionInsights(volumes),
      summary: _summary(volumes),
      trend: _trend(volumes),
    );
  }

  Map<String, double> _volumes(
      Map<String, List<WorkoutHistoryEntry>> sessions,
      ) {
    final map = <String, double>{};

    for (final entry in sessions.entries) {
      final v = entry.value.fold<double>(
        0,
            (a, b) => a + (b.weight * b.reps),
      );
      map[entry.key] = v;
    }

    return map;
  }

  List<SessionInsight> _sessionInsights(Map<String, double> v) {
    final entries = v.entries.toList()
      ..sort((a, b) => a.key.compareTo(b.key));

    return List.generate(entries.length, (i) {
      final current = entries[i].value;
      final prev = i == 0 ? current : entries[i - 1].value;

      final change = prev == 0 ? 0 : ((current - prev) / prev) * 100;

      final state = change > 5
          ? SessionState.strong
          : change < -5
          ? SessionState.weak
          : SessionState.stable;

      return SessionInsight(
        date: DateTime.now(),
        volume: current,
        changeToPrevious: change,
        state: state,
      );
    });
  }

  InsightSummary _summary(Map<String, double> v) {
    final values = v.values.toList();

    final total = values.fold<double>(0, (a, b) => a + b);
    final avg = values.isEmpty ? 0 : total / values.length;

    return InsightSummary(
      totalSessions: values.length,
      totalVolume: total,
      avgPerSession: avg,
      relativeStrength: 0,
      consistency: 0,
      interpretation: _interpret(avg),
    );
  }

  TrendInsight _trend(Map<String, double> v) {
    final values = v.values.toList();

    if (values.length < 3) {
      return const TrendInsight(
        state: TrendState.stable,
        changePercent: 0,
        message: "Noch nicht genug Daten",
      );
    }

    final recent = values.sublist(values.length - 3);
    final prevStart = values.length - 6 < 0 ? 0 : values.length - 6;
    final prev = values.sublist(prevStart, values.length - 3);

    final avgR = _avg(recent);
    final avgP = _avg(prev);

    final change = avgP == 0 ? 0 : ((avgR - avgP) / avgP) * 100;

    if (change > 5) {
      return TrendInsight(
        state: TrendState.improving,
        changePercent: change,
        message: "Du wirst stärker",
      );
    }

    if (change < -5) {
      return TrendInsight(
        state: TrendState.declining,
        changePercent: change,
        message: "Leistung sinkt",
      );
    }

    return TrendInsight(
      state: TrendState.stable,
      changePercent: change,
      message: "Stabiler Verlauf",
    );
  }

  Map<String, List<WorkoutHistoryEntry>> _group(
      List<WorkoutHistoryEntry> history,
      ) {
    final map = <String, List<WorkoutHistoryEntry>>{};

    for (final e in history) {
      map.putIfAbsent(e.sessionId, () => []).add(e);
    }

    return map;
  }

  double _avg(List<double> v) =>
      v.isEmpty ? 0 : v.reduce((a, b) => a + b) / v.length;

  String _interpret(double avg) {
    if (avg > 3000) return "Sehr hohe Trainingslast";
    if (avg > 1500) return "Solide Trainingsbasis";
    return "Aufbauphase";
  }
}