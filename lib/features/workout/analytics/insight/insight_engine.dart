import '../../domain/workout_history_entry.dart';
import 'workout_insight.dart';
import '../../application/analytics_engine.dart';

class InsightEngine {
  final AnalyticsEngine analytics;

  InsightEngine(this.analytics);

  List<WorkoutInsight> generate(List<WorkoutHistoryEntry> history) {
    final insights = <WorkoutInsight>[];

    if (history.isEmpty) return insights;

    final improving = analytics.isImproving(history);
    final volumeChange = analytics.volumeChangePercent(history);

    if (volumeChange > 10) {
      insights.add(const WorkoutInsight(
        type: InsightType.progress,
        message: '🔥 Starkes Volumen-Upgrade in dieser Session',
      ));
    }

    if (volumeChange < -10) {
      insights.add(const WorkoutInsight(
        type: InsightType.regression,
        message: '⚠️ Leistung leicht gesunken – Erholung wichtig',
      ));
    }

    if (volumeChange.abs() < 5) {
      insights.add(const WorkoutInsight(
        type: InsightType.consistency,
        message: '📊 Sehr stabile Performance',
      ));
    }

    if (improving) {
      insights.add(const WorkoutInsight(
        type: InsightType.progress,
        message: '📈 Gesamttrend zeigt Verbesserung',
      ));
    }

    return insights;
  }
}