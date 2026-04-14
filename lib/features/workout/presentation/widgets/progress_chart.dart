import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../../domain/workout_history_entry.dart';
import 'ttg_glass_card.dart';
import 'progress_chart_data.dart';
import 'progress_chart_bar.dart';

class ProgressChart extends StatelessWidget {
  final List<WorkoutHistoryEntry> history;

  const ProgressChart({super.key, required this.history});

  @override
  Widget build(BuildContext context) {
    if (history.isEmpty) return const SizedBox.shrink();

    final data = ProgressChartData.build(history);

    final maxWeight = data.weight.isEmpty
        ? 0.0
        : data.weight.map((e) => e.y).reduce((a, b) => a > b ? a : b);

    final lastIndex = history.length - 1;

    return TtgGlassCard(
      child: SizedBox(
        height: 240,
        child: LineChart(
          LineChartData(
            minX: 0,
            maxX: lastIndex.toDouble(),
            gridData: FlGridData(show: false),
            borderData: FlBorderData(show: false),
            titlesData: FlTitlesData(show: false),
            lineTouchData: LineTouchData(enabled: true),
            lineBarsData: [
              buildChartBar(
                data.weight,
                Colors.white,
                highlightIndex: lastIndex,
                highlightValue: maxWeight,
              ),
              buildChartBar(
                data.reps,
                Colors.white70,
                highlightIndex: lastIndex,
              ),
              buildChartBar(
                data.volume,
                Colors.white24,
                highlightIndex: lastIndex,
              ),
            ],
          ),
        ),
      ),
    );
  }
}