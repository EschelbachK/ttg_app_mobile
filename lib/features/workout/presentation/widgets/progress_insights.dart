import 'package:flutter/material.dart';
import '../../domain/workout_history_entry.dart';
import 'ttg_glass_card.dart';

class ProgressInsights extends StatelessWidget {
  final List<WorkoutHistoryEntry> history;

  const ProgressInsights({super.key, required this.history});

  @override
  Widget build(BuildContext context) {
    if (history.length < 2) return const SizedBox.shrink();

    final last = history.last;
    final prev = history[history.length - 2];

    final weightDiff = last.weight - prev.weight;
    final repsDiff = last.reps - prev.reps;
    final volumeDiff =
        (last.weight * last.reps) - (prev.weight * prev.reps);

    final data = _resolve(weightDiff, repsDiff, volumeDiff);

    return TtgGlassCard(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Text(
          data.text,
          style: TextStyle(color: data.color),
        ),
      ),
    );
  }

  _InsightData _resolve(double w, int r, double v) {
    if (v > 0 || w > 0 || r > 0) {
      return _InsightData('Progress 👍', Colors.green);
    }
    if (v == 0 && w == 0 && r == 0) {
      return _InsightData('Plateau', Colors.orange);
    }
    return _InsightData('Regression', Colors.red);
  }
}

class _InsightData {
  final String text;
  final Color color;

  _InsightData(this.text, this.color);
}