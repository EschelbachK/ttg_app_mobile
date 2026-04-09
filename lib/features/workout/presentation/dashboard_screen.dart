import 'package:flutter/material.dart';
import '../application/insights_engine.dart';
import '../domain/workout_history_entry.dart';
import 'widgets/progress_chart.dart';
import 'widgets/insight_card.dart';

class DashboardScreen extends StatelessWidget {
  final List<WorkoutHistoryEntry> history;

  const DashboardScreen({super.key, required this.history});

  @override
  Widget build(BuildContext context) {
    final insights = InsightsEngine().analyze(history);

    return Scaffold(
      appBar: AppBar(title: const Text('Dashboard')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          ProgressChart(history: history),
          const SizedBox(height: 16),
          ...insights.map((e) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: InsightCard(insight: e),
          )),
        ],
      ),
    );
  }
}