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

    final spots = _buildSpots();

    return TtgGlassCard(
      child: SizedBox(
        height: 260,
        child: LineChart(
          LineChartData(
            minX: 0,
            maxX: (history.length - 1).toDouble(),
            gridData: FlGridData(show: false),
            borderData: FlBorderData(show: false),
            titlesData: FlTitlesData(show: false),
            lineTouchData: LineTouchData(enabled: true),
            lineBarsData: [
              _bar(spots.weight, Colors.blue),
              _bar(spots.reps, Colors.green),
              _bar(spots.volume, Colors.orange),
            ],
          ),
        ),
      ),
    );
  }

  _ChartSpots _buildSpots() {
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

  LineChartBarData _bar(List<FlSpot> spots, Color color) {
    return LineChartBarData(
      spots: spots,
      isCurved: true,
      barWidth: 2.5,
      dotData: FlDotData(show: false),
      color: color,
    );
  }
}

class _ChartSpots {
  final List<FlSpot> weight;
  final List<FlSpot> reps;
  final List<FlSpot> volume;

  _ChartSpots(this.weight, this.reps, this.volume);
}