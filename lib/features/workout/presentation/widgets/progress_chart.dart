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

    final sorted = [...history]..sort((a, b) => a.date.compareTo(b.date));
    final spots = _buildSpots(sorted);

    final maxWeight = spots.weight.isEmpty
        ? 0.0
        : spots.weight.map((e) => e.y).reduce((a, b) => a > b ? a : b);

    final lastIndex = sorted.length - 1;

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
              _bar(
                spots.weight,
                Colors.white,
                highlightIndex: lastIndex,
                highlightValue: maxWeight,
              ),
              _bar(
                spots.reps,
                Colors.white70,
                highlightIndex: lastIndex,
              ),
              _bar(
                spots.volume,
                Colors.white24,
                highlightIndex: lastIndex,
              ),
            ],
          ),
        ),
      ),
    );
  }

  _ChartSpots _buildSpots(List<WorkoutHistoryEntry> history) {
    final weight = <FlSpot>[];
    final reps = <FlSpot>[];
    final volume = <FlSpot>[];

    for (var i = 0; i < history.length; i++) {
      final h = history[i];
      final x = i.toDouble();

      weight.add(FlSpot(x, h.weight));
      reps.add(FlSpot(x, h.reps.toDouble()));
      volume.add(FlSpot(x, h.weight * h.reps));
    }

    return _ChartSpots(weight, reps, volume);
  }

  LineChartBarData _bar(
      List<FlSpot> spots,
      Color color, {
        int? highlightIndex,
        double? highlightValue,
      }) {
    const tol = 0.0001;

    return LineChartBarData(
      spots: spots,
      isCurved: true,
      barWidth: 2.2,
      color: color,
      dotData: FlDotData(
        show: true,
        getDotPainter: (spot, percent, bar, index) {
          final isLast = highlightIndex != null && index == highlightIndex;
          final isPR = highlightValue != null &&
              (spot.y >= highlightValue - tol);

          if (isPR) {
            return FlDotCirclePainter(
              radius: 5,
              color: Colors.white,
              strokeWidth: 2,
              strokeColor: Colors.black,
            );
          }

          if (isLast) {
            return FlDotCirclePainter(
              radius: 4,
              color: color,
              strokeWidth: 1,
              strokeColor: Colors.white,
            );
          }

          return FlDotCirclePainter(radius: 0);
        },
      ),
    );
  }
}

class _ChartSpots {
  final List<FlSpot> weight;
  final List<FlSpot> reps;
  final List<FlSpot> volume;

  _ChartSpots(this.weight, this.reps, this.volume);
}