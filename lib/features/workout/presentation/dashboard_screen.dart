import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../application/insights_engine.dart';
import '../application/analytics_engine.dart';
import '../domain/workout_history_entry.dart';
import '../providers/motivation_provider.dart';
import 'widgets/progress_chart.dart';
import 'widgets/insight_card.dart';
import 'widgets/ttg_glass_card.dart';
import 'widgets/streak_widget.dart';
import 'widgets/badge_widget.dart';

class DashboardScreen extends ConsumerWidget {
  final List<WorkoutHistoryEntry> history;

  const DashboardScreen({super.key, required this.history});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final insights = InsightsEngine().analyze(history);
    final analytics = AnalyticsEngine();
    final motivator = ref.watch(motivationProvider);
    final theme = Theme.of(context);

    final totalVolume = analytics.totalVolume(history);
    final avgWeight = analytics.averageWeight(history);
    final reps = analytics.totalReps(history);
    final change = analytics.volumeChangePercent(history);
    final improving = analytics.isImproving(history);

    motivator.onStreak = (streak) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('🔥 Deine Streak ist jetzt $streak Tage!')),
      );
    };
    motivator.onPR = (prExercises) {
      for (var ex in prExercises) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('🏆 Neuer PR bei $ex!')),
        );
      }
    };

    return Scaffold(
      appBar: AppBar(title: const Text('Dashboard')),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        children: [
          StreakWidget(motivator: motivator.engine),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            children: motivator.engine.badges.map((b) => BadgeWidget(badge: b)).toList(),
          ),
          const SizedBox(height: 28),
          _SectionTitle(text: 'Overview', style: theme.textTheme.titleLarge),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(child: _KpiCard('Volume', totalVolume.toStringAsFixed(0))),
              const SizedBox(width: 12),
              Expanded(child: _KpiCard('Avg Weight', avgWeight.toStringAsFixed(1))),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(child: _KpiCard('Reps', reps.toString())),
              const SizedBox(width: 12),
              Expanded(child: _KpiCard('Change', '${change.toStringAsFixed(1)}%', highlight: improving)),
            ],
          ),
          const SizedBox(height: 28),
          _SectionTitle(text: 'Progress', style: theme.textTheme.titleLarge),
          const SizedBox(height: 12),
          ProgressChart(history: history),
          const SizedBox(height: 28),
          if (insights.isNotEmpty) ...[
            _SectionTitle(text: 'Insights', style: theme.textTheme.titleLarge),
            const SizedBox(height: 12),
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
  final TextStyle? style;

  const _SectionTitle({required this.text, this.style});

  @override
  Widget build(BuildContext context) =>
      Text(text, style: style?.copyWith(fontWeight: FontWeight.w600));
}

class _KpiCard extends StatelessWidget {
  final String label;
  final String value;
  final bool highlight;

  const _KpiCard(this.label, this.value, {this.highlight = false});

  @override
  Widget build(BuildContext context) {
    final color = highlight ? Colors.green : null;
    return TtgGlassCard(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: Theme.of(context).textTheme.bodySmall),
            const SizedBox(height: 6),
            Text(value, style: Theme.of(context).textTheme.titleLarge?.copyWith(color: color)),
          ],
        ),
      ),
    );
  }
}