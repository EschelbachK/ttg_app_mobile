import 'package:flutter/material.dart';
import '../application/insights_engine.dart';
import '../application/analytics_engine.dart';
import '../domain/workout_history_entry.dart';
import 'widgets/progress_chart.dart';
import 'widgets/insight_card.dart';
import 'widgets/ttg_glass_card.dart';

class DashboardScreen extends StatelessWidget {
  final List<WorkoutHistoryEntry> history;

  const DashboardScreen({super.key, required this.history});

  @override
  Widget build(BuildContext context) {
    final insights = InsightsEngine().analyze(history);
    final analytics = AnalyticsEngine();
    final theme = Theme.of(context);

    final totalVolume = analytics.totalVolume(history);
    final avgWeight = analytics.averageWeight(history);
    final reps = analytics.totalReps(history);

    return Scaffold(
      appBar: AppBar(title: const Text('Dashboard')),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        children: [
          _SectionTitle(
            text: 'Overview',
            style: theme.textTheme.titleLarge,
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(child: _KpiCard('Volume', totalVolume.toStringAsFixed(0))),
              const SizedBox(width: 12),
              Expanded(child: _KpiCard('Avg Weight', avgWeight.toStringAsFixed(1))),
            ],
          ),
          const SizedBox(height: 12),
          _KpiCard('Total Reps', reps.toString()),
          const SizedBox(height: 28),
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

class _KpiCard extends StatelessWidget {
  final String label;
  final String value;

  const _KpiCard(this.label, this.value);

  @override
  Widget build(BuildContext context) {
    return TtgGlassCard(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: Theme.of(context).textTheme.bodySmall),
            const SizedBox(height: 6),
            Text(
              value,
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ],
        ),
      ),
    );
  }
}