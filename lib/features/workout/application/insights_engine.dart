import '../domain/workout_history_entry.dart';
import '../domain/progress_insight.dart';

class InsightsEngine {
  List<ProgressInsight> analyze(List<WorkoutHistoryEntry> h) {
    if (h.length < 2) return [];

    final insights = <ProgressInsight>[];

    final last = h.last;
    final prev = h[h.length - 2];

    final lastVolume = _volume(last);
    final prevVolume = _volume(prev);
    final diff = lastVolume - prevVolume;

    final maxWeight =
    h.map((e) => e.weight).reduce((a, b) => a > b ? a : b);

    if (last.weight >= maxWeight) {
      insights.add(ProgressInsight('New PR achieved'));
    }

    if (diff > 0) {
      insights.add(ProgressInsight('Volume increased'));
    } else if (diff == 0) {
      insights.add(ProgressInsight('Plateau detected'));
    } else {
      insights.add(ProgressInsight('Performance dropped'));
    }

    if (h.length >= 3) {
      final t = h.sublist(h.length - 3).map(_volume).toList();

      if (t[2] > t[1] && t[1] > t[0]) {
        insights.add(ProgressInsight('Consistent progress'));
      } else if (t[2] < t[1] && t[1] < t[0]) {
        insights.add(ProgressInsight('Downward trend'));
      }
    }

    return insights;
  }

  double _volume(WorkoutHistoryEntry e) =>
      e.weight * e.reps;
}