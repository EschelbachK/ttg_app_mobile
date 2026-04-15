import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../application/dashboard_engine_provider.dart';
import 'analytics/volume_line_chart.dart';
import 'analytics/muscle_heatmap_grid.dart';
import 'analytics/session_compare_card.dart';

class DashboardStatisticsView extends ConsumerWidget {
  const DashboardStatisticsView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final engine = ref.watch(dashboardEngineProvider);

    final sessions = engine.volumePerSession();
    final heatmap = engine.muscleHeatmap();

    final compare = engine.sessions.length >= 2
        ? SessionCompareCard(
      last: sessions.last,
      previous: sessions[sessions.length - 2],
    )
        : const SizedBox();

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text(
          "VISUAL ANALYTICS",
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w900,
          ),
        ),

        const SizedBox(height: 16),

        VolumeLineChart(values: sessions),

        const SizedBox(height: 16),

        compare,

        const SizedBox(height: 16),

        const Text(
          "MUSCLE HEATMAP",
          style: TextStyle(color: Colors.white70),
        ),

        const SizedBox(height: 10),

        MuscleHeatmapGrid(data: heatmap),
      ],
    );
  }
}