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
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Dashboard')),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        children: [
          _SectionTitle(
            text: 'Progress',
            style: theme.textTheme.titleLarge,
          ),
          const SizedBox(height: 12),
          ProgressChart(history: history),
          const SizedBox(height: 28),
          if (insights.isNotEmpty) ...[
            _SectionTitle(
              text: 'Insights',
              style: theme.textTheme.titleLarge,
            ),
            const SizedBox(height: 12),
            ...insights.map(
                  (e) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: InsightCard(insight: e),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String text;
  final TextStyle? style;

  const _SectionTitle({
    required this.text,
    this.style,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: style?.copyWith(fontWeight: FontWeight.w600),
    );
  }
}