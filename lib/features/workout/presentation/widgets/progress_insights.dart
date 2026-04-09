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

    String text;
    Color color;

    if (weightDiff > 0 || repsDiff > 0) {
      text = 'Progress 👍';
      color = Colors.green;
    } else if (weightDiff == 0 && repsDiff == 0) {
      text = 'Plateau';
      color = Colors.orange;
    } else {
      text = 'Regression';
      color = Colors.red;
    }

    return TtgGlassCard(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Text(
          text,
          style: TextStyle(color: color),
        ),
      ),
    );
  }
}