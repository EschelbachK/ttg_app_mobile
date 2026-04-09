import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../../domain/workout_history_entry.dart';
import 'ttg_glass_card.dart';

class ProgressChart extends StatelessWidget {
  final List<WorkoutHistoryEntry> history;

  const ProgressChart({super.key, required this.history});

  @override
  Widget build(BuildContext context) {
    if (history.isEmpty) return const SizedBox.shrink();

    final spots = history.asMap().entries
        .map((e) => FlSpot(e.key.toDouble(), e.value.weight))
        .toList();

    return TtgGlassCard(
      child: SizedBox(
        height: 200,
        child: LineChart(
          LineChartData(
            gridData: FlGridData(show: false),
            titlesData: FlTitlesData(show: false),
            borderData: FlBorderData(show: false),
            lineBarsData: [
              LineChartBarData(
                spots: spots,
                isCurved: true,
                dotData: FlDotData(show: false),
              ),
            ],
          ),
        ),
      ),
    );
  }
}