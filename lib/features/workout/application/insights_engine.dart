import '../domain/workout_history_entry.dart';
import '../domain/progress_insight.dart';

class InsightsEngine {
  List<ProgressInsight> analyze(List<WorkoutHistoryEntry> history) {
    if (history.length < 2) return [];

    final insights = <ProgressInsight>[];

    final last = history.last;
    final prev = history[history.length - 2];

    final lastVolume = last.weight * last.reps;
    final prevVolume = prev.weight * prev.reps;

    final volumeDiff = lastVolume - prevVolume;

    final maxWeight = history
        .map((e) => e.weight)
        .reduce((a, b) => a > b ? a : b);

    final isPR = last.weight >= maxWeight;

    if (isPR) {
      insights.add(ProgressInsight('New PR achieved'));
    }

    if (volumeDiff > 0) {
      insights.add(ProgressInsight('Volume increased'));
    } else if (volumeDiff == 0) {
      insights.add(ProgressInsight('Plateau detected'));
    } else {
      insights.add(ProgressInsight('Performance dropped'));
    }

    if (history.length >= 3) {
      final last3 = history.sublist(history.length - 3);

      final trend = last3
          .map((e) => e.weight * e.reps)
          .toList();

      if (trend[2] > trend[1] && trend[1] > trend[0]) {
        insights.add(ProgressInsight('Consistent progress'));
      } else if (trend[2] < trend[1] && trend[1] < trend[0]) {
        insights.add(ProgressInsight('Downward trend'));
      }
    }

    return insights;
  }
}