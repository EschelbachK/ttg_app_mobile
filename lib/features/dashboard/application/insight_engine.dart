import '../../workout/domain/workout_history_entry.dart';
import '../domain/insight_models.dart';

class InsightEngine {
  const InsightEngine();

  InsightDashboardData build(List<WorkoutHistoryEntry> history) {
    final sessions = _group(history);
    final ordered = sessions.entries.toList()
      ..sort((a, b) =>
          a.value.first.date.compareTo(b.value.first.date));

    final volumes = _volumes(ordered);

    return InsightDashboardData(
      sessions: _sessionInsights(ordered, volumes),
      summary: _summary(volumes),
      trend: _trend(volumes),
    );
  }

  List<double> _volumes(
      List<MapEntry<String, List<WorkoutHistoryEntry>>> sessions,
      ) {
    return sessions.map((entry) {
      return entry.value.fold<double>(
        0.0,
            (a, b) => a + (b.weight * b.reps),
      );
    }).toList();
  }

  List<SessionInsight> _sessionInsights(
      List<MapEntry<String, List<WorkoutHistoryEntry>>> sessions,
      List<double> volumes,
      ) {
    return List.generate(volumes.length, (i) {
      final current = volumes[i];
      final prev = i == 0 ? current : volumes[i - 1];

      final change = prev == 0
          ? 0.0
          : (((current - prev) / prev) * 100).toDouble();

      final state = change > 5
          ? SessionState.strong
          : change < -5
          ? SessionState.weak
          : SessionState.stable;

      return SessionInsight(
        date: sessions[i].value.first.date,
        volume: current,
        changeToPrevious: change,
        state: state,
      );
    });
  }

  InsightSummary _summary(List<double> v) {
    final total = v.fold<double>(0.0, (a, b) => a + b);
    final avg = v.isEmpty ? 0.0 : total / v.length;

    return InsightSummary(
      totalSessions: v.length,
      totalVolume: total,
      avgPerSession: avg,
      relativeStrength: 0,
      consistency: 0,
      interpretation: _interpret(avg),
    );
  }

  TrendInsight _trend(List<double> v) {
    if (v.length < 3) {
      return const TrendInsight(
        state: TrendState.stable,
        changePercent: 0,
        message: "Noch nicht genug Daten",
      );
    }

    final recent = v.sublist(v.length - 3);
    final prevStart = v.length - 6 < 0 ? 0 : v.length - 6;
    final prev = v.sublist(prevStart, v.length - 3);

    final avgR = _avg(recent);
    final avgP = _avg(prev);

    final change = avgP == 0
        ? 0.0
        : (((avgR - avgP) / avgP) * 100).toDouble();

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
      v.isEmpty ? 0.0 : v.reduce((a, b) => a + b) / v.length;

  String _interpret(double avg) {
    if (avg > 3000) return "Sehr hohe Trainingslast";
    if (avg > 1500) return "Solide Trainingsbasis";
    return "Aufbauphase";
  }
}