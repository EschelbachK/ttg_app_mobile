import '../domain/workout_history_entry.dart';
import '../domain/progress_insight.dart';

class InsightsEngine {
  List<ProgressInsight> analyze(List<WorkoutHistoryEntry> history) {
    if (history.length < 2) return [];

    final last = history.last;
    final prev = history[history.length - 2];

    final volumeDiff =
        (last.weight * last.reps) - (prev.weight * prev.reps);

    final insights = <ProgressInsight>[];

    if (volumeDiff > 0) {
      insights.add(ProgressInsight('Volume increased'));
    } else if (volumeDiff == 0) {
      insights.add(ProgressInsight('Plateau detected'));
    } else {
      insights.add(ProgressInsight('Performance dropped'));
    }

    return insights;
  }
}