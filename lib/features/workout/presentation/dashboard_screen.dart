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

class DashboardScreen extends ConsumerWidget {
  final List<WorkoutHistoryEntry> history;

  const DashboardScreen({super.key, required this.history});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final insights = InsightsEngine().analyze(history);
    final analytics = AnalyticsEngine();
    final motivator = ref.watch(motivationProvider);

    final totalVolume = analytics.totalVolume(history);
    final avgWeight = analytics.averageWeight(history);
    final reps = analytics.totalReps(history);
    final change = analytics.volumeChangePercent(history);
    final improving = analytics.isImproving(history);

    final message = motivator.state.last?.message;

    return Scaffold(
      backgroundColor: Colors.black,
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          if (message != null) ...[
            _MotivationBanner(message: message),
            const SizedBox(height: 16),
          ],
          StreakWidget(motivator: motivator.engine),
          const SizedBox(height: 24),

          const _SectionTitle('Overview'),
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

          const SizedBox(height: 24),
          const _SectionTitle('Progress'),
          const SizedBox(height: 12),

          ProgressChart(history: history),

          if (insights.isNotEmpty) ...[
            const SizedBox(height: 24),
            const _SectionTitle('Insights'),
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

class _MotivationBanner extends StatelessWidget {
  final String message;
  const _MotivationBanner({required this.message});

  @override
  Widget build(BuildContext context) {
    return TtgGlassCard(
      child: Text(message),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String text;
  const _SectionTitle(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text.toUpperCase(),
      style: const TextStyle(
        fontSize: 14,
        color: Colors.white54,
        letterSpacing: 1,
      ),
    );
  }
}

class _KpiCard extends StatelessWidget {
  final String label;
  final String value;
  final bool highlight;

  const _KpiCard(this.label, this.value, {this.highlight = false});

  @override
  Widget build(BuildContext context) {
    return TtgGlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(color: Colors.white54)),
          const SizedBox(height: 6),
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: highlight ? Colors.green : Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}