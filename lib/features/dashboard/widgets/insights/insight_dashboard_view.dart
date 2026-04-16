import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../history/application/history_service.dart';
import '../../application/dashboard_view_model.dart';
import '../../application/insight_engine.dart';
import '../../domain/insight_models.dart';

class InsightDashboardView extends ConsumerWidget {
  const InsightDashboardView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final history = ref.read(historyServiceProvider);

    final vm = DashboardViewModel(
      historyService: history,
      engine: InsightEngine(),
    );

    final data = vm.build();

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text(
          "DEIN TRAINING",
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
        const SizedBox(height: 16),

        _trend(data.trend),
        const SizedBox(height: 16),

        _summary(data.summary),
        const SizedBox(height: 16),

        _insight(data.summary),
        const SizedBox(height: 16),

        _sessions(data.sessions),
      ],
    );
  }

  Widget _trend(TrendInsight t) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        "${t.message} (${t.changePercent.toStringAsFixed(1)}%)",
        style: const TextStyle(color: Colors.white),
      ),
    );
  }

  Widget _summary(InsightSummary s) {
    return Row(
      children: [
        _card("Sessions", "${s.totalSessions}"),
        const SizedBox(width: 10),
        _card("Ø Last", s.avgPerSession.toStringAsFixed(0)),
        const SizedBox(width: 10),
        _card("Gesamt", s.totalVolume.toStringAsFixed(0)),
      ],
    );
  }

  Widget _insight(InsightSummary s) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        s.interpretation,
        style: const TextStyle(color: Colors.white),
      ),
    );
  }

  Widget _card(String t, String v) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.05),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Text(t, style: const TextStyle(color: Colors.grey)),
            const SizedBox(height: 6),
            Text(v,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                )),
          ],
        ),
      ),
    );
  }

  Widget _sessions(List<SessionInsight> s) {
    return Column(
      children: s
          .map(
            (e) => Container(
          margin: const EdgeInsets.only(bottom: 10),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.05),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Session", style: const TextStyle(color: Colors.white)),
              Text("${e.volume.toStringAsFixed(0)}",
                  style: const TextStyle(color: Colors.white)),
              Text(
                "${e.changeToPrevious >= 0 ? '+' : ''}${e.changeToPrevious.toStringAsFixed(1)}%",
                style: TextStyle(
                  color: e.state == SessionState.strong
                      ? Colors.green
                      : Colors.grey,
                ),
              ),
            ],
          ),
        ),
      )
          .toList(),
    );
  }
}