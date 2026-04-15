import '../../application/analytics_engine.dart';
import '../../application/workout_summary_mapper.dart';
import '../../domain/workout_session.dart';
import '../../domain/workout_history_entry.dart';

class WorkoutSummaryViewModel {
  final AnalyticsEngine analytics;

  WorkoutSummaryViewModel(this.analytics);

  List<WorkoutHistoryEntry> history(WorkoutSession session) {
    return WorkoutSummaryMapper.toHistory(session);
  }

  double volume(List<WorkoutHistoryEntry> h) =>
      analytics.totalVolume(h);

  double avgWeight(List<WorkoutHistoryEntry> h) =>
      analytics.averageWeight(h);

  int reps(List<WorkoutHistoryEntry> h) =>
      analytics.totalReps(h);

  bool improving(List<WorkoutHistoryEntry> h) =>
      analytics.isImproving(h);

  double volumeChange(List<WorkoutHistoryEntry> h) =>
      analytics.volumeChangePercent(h);

  String insight(List<WorkoutHistoryEntry> h) {
    final change = volumeChange(h);

    if (change > 10) return "🔥 Starkes Upgrade heute";
    if (change < -10) return "⚠️ Leistung gesunken";
    return "📊 Stabile Session";
  }
}