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
          const _SectionTitle('Progress'),
          ProgressChart(history: history),
          const SizedBox(height: 20),
          if (insights.isNotEmpty) ...[
            const _SectionTitle('Insights'),
            const SizedBox(height: 8),
            ...insights.map((e) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: InsightCard(insight: e),
            )),
          ],
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String text;

  const _SectionTitle(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        text,
        style: Theme.of(context).textTheme.titleMedium,
      ),
    );
  }
}