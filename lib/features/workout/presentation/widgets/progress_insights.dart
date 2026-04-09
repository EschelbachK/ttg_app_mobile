import 'package:flutter/material.dart';
import '../../application/insights_engine.dart';
import '../../domain/workout_history_entry.dart';
import 'ttg_glass_card.dart';

class ProgressInsights extends StatelessWidget {
  final List<WorkoutHistoryEntry> history;

  const ProgressInsights({super.key, required this.history});

  @override
  Widget build(BuildContext context) {
    final insights = InsightsEngine().analyze(history);
    if (insights.isEmpty) return const SizedBox.shrink();

    final text = insights.first.message;

    return TtgGlassCard(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Text(text),
      ),
    );
  }
}