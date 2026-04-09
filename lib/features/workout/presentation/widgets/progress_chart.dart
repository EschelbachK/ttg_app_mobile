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

    final weightSpots = <FlSpot>[];
    final repsSpots = <FlSpot>[];
    final volumeSpots = <FlSpot>[];

    for (var i = 0; i < history.length; i++) {
      final h = history[i];

      weightSpots.add(FlSpot(i.toDouble(), h.weight));
      repsSpots.add(FlSpot(i.toDouble(), h.reps.toDouble()));
      volumeSpots.add(FlSpot(i.toDouble(), h.weight * h.reps));
    }

    return TtgGlassCard(
      child: SizedBox(
        height: 240,
        child: LineChart(
          LineChartData(
            gridData: FlGridData(show: false),
            titlesData: FlTitlesData(show: false),
            borderData: FlBorderData(show: false),
            lineBarsData: [
              LineChartBarData(
                spots: weightSpots,
                isCurved: true,
                dotData: FlDotData(show: false),
                color: Colors.blue,
              ),
              LineChartBarData(
                spots: repsSpots,
                isCurved: true,
                dotData: FlDotData(show: false),
                color: Colors.green,
              ),
              LineChartBarData(
                spots: volumeSpots,
                isCurved: true,
                dotData: FlDotData(show: false),
                color: Colors.orange,
              ),
            ],
          ),
        ),
      ),
    );
  }
}